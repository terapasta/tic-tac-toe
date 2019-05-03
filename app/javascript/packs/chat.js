import 'babel-polyfill'
import Vue from 'vue'
import Vuex from 'vuex'
import VueSweetAlert from 'vue-sweetalert'
import assign from 'lodash/assign'

import getData from '../helpers/getData'
import Chat from '../vue/Chat.vue'
import actions from '../vue/Chat/store/actions'
import baseState from '../vue/Chat/store/baseState'
import mutations from '../vue/Chat/store/mutations'
import getters from '../vue/Chat/store/getters'

Vue.use(Vuex)
Vue.use(VueSweetAlert)

document.addEventListener('DOMContentLoaded', async () => {
  const mountNode = document.getElementById('Chat')
  if (mountNode === null) { return }
  const state = assign(baseState, getData(mountNode))

  if (process.env.NODE_ENV === 'development') {
    console.log('[initial state]', state)
  }

  const store = new Vuex.Store({
    actions,
    state,
    mutations,
    getters,
  })

  const App = Vue.extend(assign({}, Chat, {
    store
  }))
  new App().$mount(mountNode)
})