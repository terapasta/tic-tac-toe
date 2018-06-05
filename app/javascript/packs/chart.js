/* eslint-disable no-new */
import Vue from 'vue'

import BadCountChart from '../vue/BadCountChart'
import GuestMessagesChart from '../vue/GuestMessagesChart'
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

  Array.prototype.forEach.call(document.querySelectorAll('[data-component="GuestMessagesChart"]'), (mountNode) => {
    new Vue({
      el: mountNode,
      components: { GuestMessagesChart },
      data: getData(mountNode),
      template: '<guest-messages-chart :columns="columns" />'
    })
  })
})
