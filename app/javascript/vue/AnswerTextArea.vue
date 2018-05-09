<script>
import isEmpty from 'is-empty'
import debounce from "lodash/debounce"

import * as QuestionAnswerAPI from "../api/questionAnswer";

const isIE = navigator.userAgent.search("Trident") >= 0
const KeyCodes = {
  IMEInputting: 229,
  Enter: 13,
  Backspace: 8,
  Delete: 46
}

export default {
  props: {
    defaultValue: { type: String, required: true },
    botId: { type: Number, required: true },
  },

  data: () => ({
    isIMEInputting: false,
    answers: [],
    answer: ''
  }),

  created () {
    this.answer = this.defaultValue
  },

  computed: {
    isExistAnswers () {
      return this.answers.length > 0
    }
  },

  methods: {
    handleTextAreaKeyDown (e) {
      this.isIMEInputting = e.keyCode === KeyCodes.IMEInputting && isIE
    },

    handleTextAreaKeyUp (e) {
      if (isIE) {
        this.handleTextAreaKeyUpForIE(e)
      } else {
        this.handleTextAreaKeyUpForModernBrowsers(e)
      }
    },

    handleTextAreaKeyUpForIE (e) {
      const isTargetKeyCode = (
        (e.keyCode === KeyCodes.Enter && this.isIMEInputting) ||
        e.keyCode === KeyCodes.Backspace || e.keyCode === KeyCodes.Delete
      )
      if (isTargetKeyCode) {
        this.isIMEInputting = false
        const { value } = e.target
        if (!isEmpty(value)) {
          this.searchAnswers(value)
        } else {
          this.answers = []
        }
      }
    },

    handleTextAreaKeyUpForModernBrowsers (e) {
      const { value } = e.target
      if (!isEmpty(value)) {
        this.searchAnswers(value)
      } else {
        this.answers = []
      }
    },

    searchAnswers: debounce(function(text) {
      QuestionAnswerAPI.findAll(this.botId, { q: text }).then((res) => {
        this.answers = res.data.questionAnswers
          .filter(it => it.answer !== this.answer)
          .map(it => it.answer)
      }).catch(console.error)
    }, 250),

    handleSuggestItemClick (answer) {
      this.answer = answer
      this.answers = []
    }
  }
}
</script>

<template>
  <div class="form-group">
    <label>回答</label>
    <textarea
      class="form-control"
      rows="5"
      v-model="answer"
      @keydown="handleTextAreaKeyDown"
      @keyup="handleTextAreaKeyUp"
    />
    <div class="card" v-if="isExistAnswers">
      <label class="m-3">回答の候補</label>
      <div
        class="suggest-item"
        v-for="(answer, i) in answers"
        :key="i"
        @click="handleSuggestItemClick(answer)"
      >
        {{answer}}
      </div>
    </div>
  </div>
</template>

<style scoped>
.form-group {
  position: relative;
}
.card {
  overflow-y: auto;
  position: absolute;
  top: calc(100% - 1px);
  left: 0;
  right: 0;
  z-index: 10;
  max-height: 200px;
  box-shadow: 0 2px 5px rgba(0,0,0,.2);
  border-radius: 0 0 0.25rem 0.25rem;
}
.suggest-item {
  cursor: pointer;
  display: block;
  padding: 16px;
  border-top: 1px solid #ccc;
  background-color: #fff;
}
.suggest-item:hover {
  background-color: #efefef;
}
</style>