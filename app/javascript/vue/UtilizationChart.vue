<script>
import C3 from 'c3'
import 'c3/c3.min.css'

import dateFnsformatDate from 'date-fns/format'
import parseDate from 'date-fns/parse'
import addDays from 'date-fns/add_days'
import jaLocale from 'date-fns/locale/ja'

import max from 'lodash/max'
import flatten from 'lodash/flatten'
import sortBy from 'lodash/sortBy'

const DateFormat = 'MM-DD'
const formatDate = date => dateFnsformatDate(date, DateFormat, { locale: jaLocale })

export default {
  props: {
    columns: { type: Array, required: true },
    yMax: { type: Number }
  },

  mounted () {
    this.$nextTick(() => {
      this.renderChart()
    })
  },

  computed: {
    yAxisMax () {
      if (this.yMax) {
        return this.yMax + 10
      } else {
        const all = flatten(this.columns.slice(1).map(it => it.slice(1)))
        return max(all) + 10
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
          columns: this.columns,
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
    }
  }
}
</script>

<template>
  <div>
    <div ref="chart" />
  </div>
</template>

<style>
</style>
