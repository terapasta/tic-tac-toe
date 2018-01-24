import Vue from 'vue'
import Vuex from 'vuex'
import VueSweetAlert from 'vue-sweetalert'
import assign from 'lodash/assign'
import isEmpty from 'is-empty'

import getData from '../helpers/getData'
import ConversationTree from '../vue/ConversationTree.vue'
import actions from '../vue/ConversationTree/store/actions'
import baseState from '../vue/ConversationTree/store/baseState'
import mutations from '../vue/ConversationTree/store/mutations'
import router from '../vue/ConversationTree/router'

Vue.use(Vuex)
Vue.use(VueSweetAlert)

document.addEventListener('DOMContentLoaded', () => {
  const mountNode = document.getElementById('ConversationTree')
  if (mountNode === null) { return }
  const state = assign(baseState, getData(mountNode))

  if (process.env.NODE_ENV === 'development') {
    console.log('[initial state]', state)
  }

  const store = new Vuex.Store({
    actions,
    mutations,
    state
  })

  new Vue({
    el: mountNode,
    template: '<ConversationTree />',
    components: { ConversationTree },
    store,
    router
  })
})
