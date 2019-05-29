<script>
import axios from 'axios'
import C3 from 'c3'
import FlatPickr from 'vue-flatpickr-component'
import 'c3/c3.min.css'
import 'flatpickr/dist/flatpickr.css'
import { Japanese } from "flatpickr/dist/l10n/ja.js"

import dateFnsformatDate from 'date-fns/format'
import parseDate from 'date-fns/parse'
import jaLocale from 'date-fns/locale/ja'
import addDays from 'date-fns/add_days'
import subDays from 'date-fns/sub_days'

import max from 'lodash/max'
import flatten from 'lodash/flatten'
import get from 'lodash/get'

const DateFormat = 'MM-DD'
const formatDate = date => dateFnsformatDate(date, DateFormat, { locale: jaLocale })
const today = new Date()

const DateFormatForQueryParams = 'YYYY-MM-DD'
const Week = { Sunday: 0 }

const flatpickrBaseConfig = {
  dateFormat: 'y-m-d',
  locale: Japanese
}

export default {
  components: {
    FlatPickr
  },

  mounted() {
    this.$nextTick(() => {
      this.displayData = this.columns
      this.renderChart()
    })
  },

  watch: {
    columns: {
      immediate: true,
      handler(columns) {
        this.displayData = columns
        this.renderChart()
      }
    }
  },

  data: () => ({
    displayData: [],
    monthlyData: [],
    halfYearData: [],
    isNeedDatepicker: false,
    dateFrom: null,
    dateTo: null
  }),

  props: {
    columns: { type: Array },
    bot: { type: Object, required: true },
    onlyGm: { type: Boolean, default: false }
  },

  computed: {
    yAxisMax () {
      if (this.yMax == null) {
        const all = flatten(this.displayData.slice(1).map(it => it.slice(1)))
        return max(all) + 10
      }
      return this.yMax + 10
    },

    weeklyData () {
      const defaultData = [...this.columns]
      const data = []
      defaultData.forEach(target => {
        data.push(target.slice(0, 8))
      })
      return data
    },

    toggleTermSearchText () {
      return this.isNeedDatepicker ? "決まった期間から選択" : "自分で期間を指定"
    },

    botCreatedAt () {
      return new Date(this.bot.created_at)
    },

    flatpickrFromConfig () {
      return {
        ...flatpickrBaseConfig,
        maxDate: subDays(today, 7),
        minDate: this.botCreatedAt
      }
    },

    flatpickrToConfig () {
      const dateFrom = `20${this.dateFrom}`
      const minDate = this.dateFrom ? addDays(new Date(dateFrom), 7) : today
      return {
        ...flatpickrBaseConfig,
        maxDate: today,
        minDate
      }
    }
  },

  methods: {
    renderChart() {
      this.chart = C3.generate({
        bindto: this.$refs.chart,
        size: {
          height: 300
        },
        data: {
          x: 'x',
          columns: this.displayData,
          type: 'line',
        },
        axis: {
          x: {
            type: 'timeseries',
            tick: {
              format (d) {
                const date = parseDate(d)
                return formatDate(date)
              }
            }
          },
          y: {
            padding: 0,
            max: this.yAxisMax,
            min: 0,
          }
        },
        legend: {
          show: false
        }
      })
    },

    async handleHalfYearClicked () {
      if (this.halfYearData.length > 0) {
        this.displayData = [...this.halfYearData]
      } else {
        this.displayData = await this.utilizationDataWithTerm()
        this.halfYearData = [...this.displayData]
      }
      this.renderChart()
    },

    handleMonthlyClicked () {
      this.displayData = this.columns
      this.renderChart()
    },

    handleWeeklyClicked () {
      this.displayData = this.weeklyData
      this.renderChart()
    },

    async utilizationDataWithTerm () {
      const params = { half_year: true, bot_id: this.bot.id }
      const res = await axios.get('/admin/post_utilizations', { params })
      const data = get(res, 'data.data', null)
      if (!data) { return }

      return this.onlyGm
        ? this.convertDataToWeeklyForGusetMessages(data)
        : this.convertDataToWeekly(data)
    },

    convertDataToWeekly (data) {
      const defaultDate = [...data[0]]
      const defaultGm = [...data[1]]
      const defaultQa = [...data[2]]
      const defaultUpdateQa = [...data[3]]

      // set headers
      let dates = [defaultDate.shift()]
      let guestMessages = [defaultGm.shift()]
      let questionAnswers = [defaultQa.shift()]
      let updateQas = [defaultUpdateQa.shift()]

      defaultDate.forEach((date, i) => {
        const day = parseDate(date).getDay()

        if (i === 0 && day !== Week.Sunday) {
        // for first week 
        // --> previous Sunday to yesterday (skip if yesterday is Sunday)
          dates.push(date)
          guestMessages.push(this.calcWeeklyData(defaultGm, 0, day))
          questionAnswers.push(defaultQa[i] || 0)
          updateQas.push(this.calcWeeklyData(defaultUpdateQa, 0, day))
        }
        else if (day === Week.Sunday) {
          dates.push(date)
          guestMessages.push(this.calcWeeklyData(defaultGm, i, i + 7))
          questionAnswers.push(defaultQa[i] || 0)
          updateQas.push(this.calcWeeklyData(defaultUpdateQa, i, i + 7))
        }
      })

      return [
        [...dates],
        [...guestMessages],
        [...questionAnswers],
        [...updateQas]
      ]
    },

    convertDataToWeeklyForGusetMessages (data) {
      const defaultDate = [...data[0]]
      const defaultGm = [...data[1]]

      // set headers
      let dates = [defaultDate.shift()]
      let guestMessages = [defaultGm.shift()]

      defaultDate.forEach((date, i) => {
        const day = parseDate(date).getDay()

        if (i === 0 && day !== Week.Sunday) {
        // data for first week -> previous Sunday to yesterday
          dates.push(date)
          guestMessages.push(this.calcWeeklyData(defaultGm, 0, day))
        }
        else if (day === Week.Sunday) {
          dates.push(date)
          guestMessages.push(this.calcWeeklyData(defaultGm, i, i + 7))
        }
      })

      return [
        [...dates],
        [...guestMessages]
      ]
    },

    calcWeeklyData (defaultData, start, end) {
      if (!defaultData || !defaultData[start]) { return 0 }
      return defaultData.slice(start, end).reduce((acc, val) => acc + val)
    },

    async utilizationDataWithFromTo () {
      if (!this.dateFrom || !this.dateTo) { return }
      const res = await axios.get('/admin/post_utilizations', { params })
      const data = get(res, 'data.data', null)
      
    }
  }
}
</script>

<template>
  <div>
    <div class="d-flex flex-row-reverse mb-1">
      <div v-if="isNeedDatepicker"
        class="d-flex justify-content-end"
      >
      <flat-pickr
        v-model="dateFrom"
        :config="flatpickrFromConfig"
        class="col-3 mr-1 text-center form-control picker-input bg-white"
      />
      <span class="align-self-center">〜</span>
      <flat-pickr
        v-model="dateTo"
        :config="flatpickrToConfig"
        class="col-3 ml-1 text-center form-control picker-input bg-white"
      />
      </div>
      <div v-else
        class="btn-group btn-group-toggle"
        data-toggle="buttons"
      >
        <label
          class="btn btn-sm btn-outline-info"
          @click="handleHalfYearClicked"
        >
          <input type="radio" autocomplete="off">半年
        </label>
        <label
          class="btn btn-sm btn-outline-info active"
          @click="handleMonthlyClicked"
        >
          <input type="radio" autocomplete="off">月
        </label>
        <label
          class="btn btn-sm btn-outline-info"
          @click="handleWeeklyClicked"
        >
          <input type="radio" autocomplete="off">週
        </label>
      </div>
    </div>
    <div class="d-flex flex-row-reverse mb-3">
      <button
        class="btn btn-sm btn-link text-muted"
        @click="isNeedDatepicker = !isNeedDatepicker"
      >{{toggleTermSearchText}}</button>
    </div>
    <div ref="chart"/>
  </div>
</template>

<style scoped lang="scss">
.picker-input {
  height: 2rem;
  font-size: .8rem;
}
</style>
