<script>
import C3 from 'c3'
import 'c3/c3.min.css'
import axios from 'axios'

import dateFnsformatDate from 'date-fns/format'
import parseDate from 'date-fns/parse'
import jaLocale from 'date-fns/locale/ja'

import max from 'lodash/max'
import flatten from 'lodash/flatten'
import get from 'lodash/get'

const DateFormat = 'MM-DD'
const formatDate = date => dateFnsformatDate(date, DateFormat, { locale: jaLocale })

const DateFormatForQueryParams = 'YYYY-MM-DD'
const HalfYearDays = 182

export default {

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
    monthlyData: []
  }),

  props: {
    columns: { type: Array },
    botId: { type: Number }
  },

  computed: {
    yAxisMax () {
      if (this.yMax == null) {
        const all = flatten(this.columns.slice(1).map(it => it.slice(1)))
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
      const params = {
        half_year: true,
        bot_id: this.botId
      }
      axios.get('/admin/post_utilizations', { params })
      .then(res => {
        const data = get(res, 'data.data', null)
        if (!data) { return }
        this.displayData = this.modifyHalfYearData(data)
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
        if (i === 0 && day !== 0) {
          dates.push(date)
          guestMessages.push(this.calcWeeklyData(defaultGm, 0, day))
          questionAnswers.push(defaultQa[i] || 0)
          updateQas.push(this.calcWeeklyData(defaultUpdateQa, 0, day))
        }
        if (day === 0) {
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

    calcWeeklyData (defaultData, start, end) {
      if (!defaultData || !defaultData[start]) { return 0 }
      return defaultData.slice(start, end).reduce((acc, val) => acc + val)
    }
  }
}
</script>

<template>
  <div>
    <div class="d-flex flex-row-reverse mb-3">
      <div class="btn-group" role="group">
        <button
          class="btn btn-sm btn-outline-info"
          @click="handleHalfYearClicked"
        >半年
        </button>
        <button
          class="btn btn-sm btn-outline-info"
          @click="handleMonthlyClicked"
        >月
        </button>
        <button
          class="btn btn-sm btn-outline-info"
          @click="handleWeeklyClicked"
        >週</button>
      </div>
    </div>
    <div ref="chart"/>
  </div>
</template>

<style>
</style>
