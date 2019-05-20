<script>
import C3 from 'c3'
import 'c3/c3.min.css'

import dateFnsformatDate from 'date-fns/format'
import parseDate from 'date-fns/parse'
import jaLocale from 'date-fns/locale/ja'

import max from 'lodash/max'
import flatten from 'lodash/flatten'
import sortBy from 'lodash/sortBy'

const DateFormat = 'MM-DD'
const formatDate = date => dateFnsformatDate(date, DateFormat, { locale: jaLocale })

const today = dateFnsformatDate(new Date(), 'YYYY-MM-DD')

export default {

  mounted () {
    this.$nextTick(async () => {
      this.displayData = this.columns
      this.renderChart()
    })
  },

  data: () => ({
    displayData: [],
    monthlyData: []
  }),

  props: {
    columns: { type: Array }
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

    handleHalfYearClicked () {
    },

    handleMonthlyClicked () {
      this.displayData = this.columns
      this.renderChart()
    },

    handleWeeklyClicked () {
      this.displayData = this.weeklyData
      this.renderChart()
    }
  }
}
</script>

<template>
  <div>
    <div class="d-flex flex-row-reverse mb-3">
      <div class="btn-group" role="group">
        <button
          type="button"
          id="halfYearButton"
          class="btn btn-sm btn-outline-info"
          @click="handleHalfYearClicked"
        >半年
        </button>
        <button
          type="button"
          id="monthlyButton"
          class="btn btn-sm btn-outline-info"
          @click="handleMonthlyClicked"
        >月
        </button>
        <button
          type="button"
          id="weeklyButton"
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
