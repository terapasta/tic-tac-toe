<script>
import C3 from 'c3'
import 'c3/c3.min.css'

const Colors = {
  Danger: '#dc3545',
  Warning: '#ffc107',
  Safe: '#28a745'
}

const Thresolds = {
  Safe: 10,
  Warining: 20
}

export default {
  props: {
    columns: { type: Array, required: true }
  },

  mounted () {
    this.$nextTick(() => {
      this.renderChart()
    })
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
          type: 'bar',
          color (color, d) {
            if (d.value <= Thresolds.Safe) {
              return Colors.Safe
            } else if (d.value <= Thresolds.Warining) {
              return Colors.Warning
            } else {
              return Colors.Danger
            }
          }
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
            max: 100,
            min: 0,
            tick: {
              format (d) { return `${d}%` }
            }
          }
        },
        grid: {
          y: {
            lines: [
              { value: 0, text: '正常(0〜10%)', position: 'end', class: 'threshold-label' },
              { value: 10, text: '注意(11〜20%)', position: 'end', class: 'threshold-label' },
              { value: 20, text: '危険(21〜100%)', position: 'end', class: 'threshold-label' }
            ]
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

<style lang="scss">
.threshold-label {
  text {
    fill: #000 !important;
  }
}
</style>