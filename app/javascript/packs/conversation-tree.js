import Vue from 'vue'
import Vuex from 'vuex'
import VueSweetAlert from 'vue-sweetalert'
import assign from 'lodash/assign'

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
  // state.filteredQuestionsTree = state.questionsTree.concat()
  // state.filteredQuestionsSelectableTree = state.questionsTree.concat()

  if (process.env.NODE_ENV === 'development') {
    console.log('[initial state]', state)
  }

  const store = new Vuex.Store({
    actions,
    state,
    mutations
  })

  const App = Vue.extend(assign({}, ConversationTree, {
    store,
    router
  }))
  new App().$mount(mountNode)
})
