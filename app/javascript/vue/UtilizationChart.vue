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
import differenceInYears from 'date-fns/difference_in_years'

import max from 'lodash/max'
import flatten from 'lodash/flatten'
import get from 'lodash/get'

import {
  oneWeekData,
  oneWeekDataForGm,
  convertData,
  convertDataForGm
} from '../helpers/convertUtilizationData'

const today = new Date()
const DateFormat = 'MM-DD'
const DateFormatWithYear = 'YY-MM-DD'
const DateFormatForQueryParams = 'YYYY-MM-DD'
const formatDate = date => dateFnsformatDate(date, DateFormat, { locale: jaLocale })
const formatDateWithYear = date => dateFnsformatDate(date, DateFormatWithYear, { locale: jaLocale })

const flatpickrBaseConfig = {
  dateFormat: 'y-m-d',
  locale: Japanese
}

export default {
  components: { FlatPickr },

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
    oneWeekData: [],
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
    renderChart(withYear) {
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
                return withYear ? formatDateWithYear(date) : formatDate(date)
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
        const params = { half_year: true, bot_id: this.bot.id }
        const res = await axios.get('/admin/post_utilizations', { params })
        const data = get(res, 'data.data', null)
        this.displayData = this.utilizationDataWithTerm(data)
        this.halfYearData = [...this.displayData]
      }
      this.renderChart()
    },

    handleMonthlyClicked () {
      this.displayData = this.columns
      this.renderChart()
    },

    handleWeeklyClicked () {
      if (this.oneWeekData.lenght > 0) {
        this.displayData = [...this.oneWeekData]
      } else {
        this.displayData = this.onlyGm
          ? oneWeekDataForGm(this.columns)
          : oneWeekData(this.columns)
        this.oneWeekData = [...this.displayData]
      }
      
      this.renderChart()
    },

    utilizationDataWithTerm (data) {
      if (!data) { return }
      return this.onlyGm ? convertDataForGm(data) : convertData(data)
    },

    async utilizationDataWithFromTo () {
      if (!this.dateFrom || !this.dateTo) { return }
      const params = {
        start_time: this.dateFrom,
        end_time: this.dateTo,
        bot_id: this.bot.id
      }
      const res = await axios.get('/admin/post_utilizations', { params })
      const data = get(res, 'data.data', null)
      this.displayData = this.utilizationDataWithTerm(data)
      const withYear = differenceInYears(`20${this.dateTo}`, `20${this.dateFrom}`) > 0
      this.renderChart(withYear)
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
        @input="utilizationDataWithFromTo"
        class="col-3 mr-1 text-center form-control picker-input bg-white"
      />
      <span class="align-self-center">〜</span>
      <flat-pickr
        v-model="dateTo"
        :config="flatpickrToConfig"
        @input="utilizationDataWithFromTo"
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
