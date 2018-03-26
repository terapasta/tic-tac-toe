import Vue from 'vue'

import TimeseriesChart from '../vue/TimeseriesChart'
import getData from '../helpers/getData'

document.addEventListener('DOMContentLoaded', () => {
  Array.prototype.forEach.call(document.querySelectorAll('[data-component="TimeseriesChart"]'), (mountNode) => {
    new Vue({
      el: mountNode,
      components: { TimeseriesChart },
      data: getData(mountNode),
      template: '<timeseries-chart :columns="columns" />'
    })
  })
})
