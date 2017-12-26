import Vue from 'vue'
import ConversationTree from '../vue/ConversationTree.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#ConversationTree',
    template: '<ConversationTree />',
    components: { ConversationTree }
  })
})
