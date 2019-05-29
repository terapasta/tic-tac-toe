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

import max from 'lodash/max'
import flatten from 'lodash/flatten'
import get from 'lodash/get'

const DateFormat = 'MM-DD'
const formatDate = date => dateFnsformatDate(date, DateFormat, { locale: jaLocale })

const DateFormatForQueryParams = 'YYYY-MM-DD'
const Week = { Sunday: 0 }

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
    dateTo: null,
    flatpickrConfig: {
      dateFormat: 'm-d',
      locale: Japanese
    }
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

    handleHalfYearClicked (botId) {
      if (this.halfYearData.length > 0) {
        this.displayData = this.halfYearData
        this.renderChart()
        return
      }
      const params = {
        half_year: true,
        bot_id: this.bot.id
      }
      axios.get('/admin/post_utilizations', { params })
      .then(res => {
        const data = get(res, 'data.data', null)
        if (!data) { return }
        this.displayData = this.onlyGm
        ? this.modifyHalfYearDataForGusetMessages(data)
        : this.modifyHalfYearData(data)

        this.halfYearData = [...this.displayData]
        this.renderChart()
      })
    },

    handleMonthlyClicked () {
      this.displayData = this.columns
      this.renderChart()
    },

    handleWeeklyClicked () {
      this.displayData = this.weeklyData
      this.renderChart()
    },

    modifyHalfYearData (data) {
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

    modifyHalfYearDataForGusetMessages (data) {
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
        :config="flatpickrConfig"
        class="col-3 mr-1 text-center form-control picker-input"
      />
      <span class="align-self-center">〜</span>
      <flat-pickr
        v-model="dateTo"
        :config="flatpickrConfig"
        class="col-3 ml-1 text-center form-control picker-input"
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
}
</style>
