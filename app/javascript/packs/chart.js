/* eslint-disable no-new */
import Vue from 'vue'

import BadCountChart from '../vue/BadCountChart'
import BadRateChart from '../vue/BadRateChart'
import UtilizationChart from '../vue/UtilizationChart'
import Utilization from '../vue/Utilization'
import getData from '../helpers/getData'

document.addEventListener('DOMContentLoaded', () => {
  Array.prototype.forEach.call(document.querySelectorAll('[data-component="BadCountChart"]'), (mountNode) => {
    new Vue({
      el: mountNode,
      components: { BadCountChart },
      data: getData(mountNode),
      template: '<bad-count-chart :columns="columns" />'
    })
  })

  Array.prototype.forEach.call(document.querySelectorAll('[data-component="BadRateChart"]'), (mountNode) => {
    new Vue({
      el: mountNode,
      components: { BadRateChart },
      data: getData(mountNode),
      template: '<bad-rate-chart :columns="columns" />'
    })
  })

  Array.prototype.forEach.call(document.querySelectorAll('[data-component="UtilizationChart"]'), (mountNode) => {
    new Vue({
      el: mountNode,
      components: { UtilizationChart },
      data: getData(mountNode),
      template: `
        <utilization-chart
          :columns="columns"
          :bot-id="botId"
          :only-gm="true" 
        />`
    })
  })

  Array.prototype.forEach.call(document.querySelectorAll('[data-component="Utilization"]'), (mountNode) => {
    new Vue({
      el: mountNode,
      components: { Utilization },
      template: `
        <utilization />
      `
    })
  })
})
