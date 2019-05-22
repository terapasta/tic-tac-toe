/* eslint-disable no-new */
import Vue from 'vue'

import BadCountChart from '../vue/BadCountChart'
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
