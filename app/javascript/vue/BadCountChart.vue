<script>
import C3 from 'c3'
import 'c3/c3.min.css'
import max from 'lodash/max'

const Colors = {
  Danger: '#dc3545',
  Warning: '#ffc107',
  Safe: '#28a745',
  Line: '#0000ff'
}

const Thresolds = {
  Safe: 10,
  Warning: 20
}

const YAxisMax = {
  Lower: 25,
  Higher: 100
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

  computed: {
    yAxisMax () {
      const result = max(this.columns[1].slice(1)) + 10
      return result > YAxisMax.Higher ? YAxisMax.Higher : (result < YAxisMax.Lower ? YAxisMax.Lower : result)
    },
    y2AxisMax () {
      const result = max(this.columns[2].slice(1)) 
      return result === 0 ? 100 : (result <= 100 ? 100 : result + 10)
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
          axes: {
            'Bad評価件数': 'y2'
          },
          types: {
            'Bad評価率': 'bar',
            'Bad評価件数': 'line'
          },
          color (color, d) {
            if (d.id === 'Bad評価件数') {
              return Colors.Line
            }
            if (d === 'Bad評価率') {
              return '#fff'
            } else if (d.value <= Thresolds.Safe) {
              return Colors.Safe
            } else if (d.value <= Thresolds.Warning) {
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
            max: this.yAxisMax,
            min: 0,
            tick: {
              format (d) { return `${d}%` }
            },
            label: {
              text: 'Bad評価率',
              position: 'outer-middle'
            }
          },
          y2: {
            show: true,
            padding: 0,
            max: this.y2AxisMax,
            min: 0,
            tick: {
              format (d) { return `${d}件` }
            },
            label: {
              text: 'Bad評価件数',
              position: 'outer-middle'
            }
          }
        },
        tooltip: {
          contents: function (d, defaultTitleFormat, defaultValueFormat, color) {
            const dataColor = (data) => {
              if (!data || !data.value) { return "#fff" }
              const { value } = data
              switch (true) {
                case value <= Thresolds.Safe:
                  return Colors.Safe
                case value <= Thresolds.Warning:
                  return Colors.Warning
                default:
                  return Colors.Danger
              }
            }

            const $$ = this
            const titleFormat = defaultTitleFormat
            const nameFormat = (name) => { return name }
            const valueFormat = defaultValueFormat
            let text, i, title, value, name, bgcolor
            for (i = 0; i < d.length; i++) {
              if (!(d[i] && (d[i].value || d[i].value === 0))) {
                continue;
              }
              if (!text) {
                title = titleFormat ? titleFormat(d[i].x) : d[i].x;
                text = "<table class='c3-tooltip c3-tooltip-container'>" + (title || title === 0 ? "<tr><th colspan='2'>" + title + "</th></tr>" : "");
              }
              name = nameFormat(d[i].name, d[i].ratio, d[i].id, d[i].index);
              value = valueFormat(d[i].value, d[i].ratio, d[i].id, d[i].index);
              bgcolor = d[i].id === 'Bad評価件数' ? Colors.Line : dataColor(d[i]);
              text += "<tr class='" + d[i].id + "'>";
              text += "<td class='name'><span style='background-color:" + bgcolor + "'></span>" + name + "</td>";
              text += "<td class='value'>" + value.toLocaleString() + "</td>";
              text += "</tr>";
            }
            return text;
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