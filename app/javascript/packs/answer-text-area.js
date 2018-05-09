import Vue from 'vue'

import getData from '../helpers/getData'
import AnswerTextArea from '../vue/AnswerTextArea.vue'

document.addEventListener('DOMContentLoaded', () => {
  const mountNode = document.querySelector('[data-component="AnswerTextArea"]')
  if (mountNode == null) { return }

  new Vue({
    el: mountNode,
    components: { AnswerTextArea },
    data: getData(mountNode),
    template: `
      <answer-text-area
        :default-value="defaultValue"
        :bot-id="botId"
      />
    `
  })
})
