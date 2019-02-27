<script>
import isEmpty from 'is-empty'
import debounce from "lodash/debounce"

import * as QuestionAnswerAPI from '../api/questionAnswer'
import * as AnswerInlineImageAPI from '../api/answerInlineImage'

const isIE = navigator.userAgent.search("Trident") >= 0

export default {
  props: {
    defaultValue: { type: String, default: '' },
    name: { type: String, default: 'question_answer[answer]' },
    disabled: { type: Boolean, default: false },
    isHiddenLabel: { type: Boolean, default: false }
  },

  data: () => ({
    isIMEInputting: false,
    answers: [],
    answer: '',
    isProcessing: false,
    botId: window.currentBot.id,
    errMsg: ''
  }),

  created () {
    this.answer = this.defaultValue
  },

  computed: {
    isExistAnswers () {
      return this.answers.length > 0
    }
  },

  watch: {
    defaultValue (newVal) {
      this.answer = newVal
    }
  },

  methods: {
    handleTextAreaKeyUp (e) {
      const { value } = e.target
      this.$emit('keyup', value)
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
      this.$emit('keyup', answer)
    },

    handleFileInputChange (e) {
      if (this.isProcessing) { return }
      const file = e.target.files[0]
      if (file == null) { return }

      this.errMsg = ''

      // from AnswerInlineImageUploader#extension_whitelist(ruby)
      let extensionWhiteList = /(\.jpg|\.jpeg|\.gif|\.png)$/i
      if (!extensionWhiteList.exec(file.name)) {
        this.errMsg = '拡張子が .jpg .jpeg .gif .png の画像ファイルのみ追加可能です'
        return false
      }

      if (file.size > 10*1024*1024 /* = 10MB */) {
        this.errMsg = '画像サイズは10MB以下となるものを選択してください'
        return false
      }
      const { botId } = this
      this.isProcessing = true

      AnswerInlineImageAPI.upload({ botId, file }).then(res => {
        this.isProcessing = false
        const { url } = res.data.answerInlineImage.file
        const markdown = `\n![${file.name}](${url})\n`
        const insertPosition = this.$refs.textArea.selectionStart
        const headText = this.answer.slice(0, insertPosition)
        const tailText = this.answer.slice(insertPosition)
        this.answer = headText + markdown + tailText
        this.$emit('keyup', this.answer)
        // prevent inline image from being submitted by "送信" button
        this.$refs.answerInlineImage.value = ''
      }).catch(err => {
        console.error(err)
        this.isProcessing = false
      })
    }
  }
}
</script>

<template>
  <div class="form-group">
    <div class="d-flex justify-content-between align-items-center">
      <label class="mb-0">
        <span v-if="!isHiddenLabel">
          <i class="material-icons" title="回答">chat_bubble_outline</i>&nbsp;回答（本文中に10MB以下の画像を追加できます）
        </span>
      </label>
      <div
        class="btn btn-link file-input-container py-1"
        title="クリックして回答本文中に画像を追加できます"
      >

        <i class="material-icons">add_photo_alternate</i>
        <input
          ref="answerInlineImage"
          type="file"
          class="file-input"
          name="answer-inline-image"
          id="answer-inline-image"
          @change="handleFileInputChange"
        />
      </div>
    </div>
    <textarea
      id="answer-body"
      class="form-control"
      rows="5"
      ref="textArea"
      name="question_answer[answer]"
      v-model="answer"
      :disabled="isProcessing || disabled"
      @keyup="handleTextAreaKeyUp"
    />
    <p
      v-if="errMsg"
      class="alert alert-danger mt-2"
    >
      {{ errMsg }}
    </p>
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
.file-input-container {
  position: relative;
}
.file-input {
  display: block;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0;
  width: 100%;
  height: 100%;
}
</style>