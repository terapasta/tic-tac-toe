<script>
import C3 from 'c3'
import 'c3/c3.min.css'
import max from 'lodash/max'

export default {
  props: {
    columns: { type: Array, required: true }
  },

  mounted () {
    this.$nextTick(() => {
      this.renderChart()
    })
  },

  computed: {
    yAxisMax () {
      const result = max(this.columns[1].slice(1)) + 10
      return result
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
              format: '%Y-%m-%d'
            }
          },
          y: {
            padding: 0,
            max: this.yAxisMax,
            min: 0
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