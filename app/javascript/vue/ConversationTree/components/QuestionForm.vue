<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'

import QuestionIcon from './QuestionIcon'
import AnswerIcon from './AnswerIcon'
import QuestionAnswerFormMixin from '../mixins/QuestionAnswerForm'

export default {
  mixins: [
    QuestionAnswerFormMixin
  ],

  components: {
    QuestionIcon,
    AnswerIcon
  },

  data: () => ({
    questionAnswer: {},
    isNew: false,
    isProcessing: false
  }),

  mounted () {
    this.setParent()
  },

  watch: {
    $route () {
      this.setParent()
    }
  },

  computed: {
    ...mapState([
      'questionsRepo',
      'questionsTree'
    ])
  },

  methods: {
    ...mapActions([
      'createQuestionAnswer',
      'updateQuestionAnswer',
      'deleteQuestionAnswer'
    ])
  }
}
</script>

<template>
  <div>
    <div class="form-group">
      <label><question-icon />&nbsp;質問</label>
      <textarea
        id="question"
        name="question-question"
        class="form-control"
        placeholder="質問を入力してください（例：カードキー無くしてしまったのですが、どうすればいいですか）"
        v-model="questionAnswer.question"
        :disabled="isProcessing"
      />
    </div>
    <div class="form-group">
      <label><answer-icon />&nbsp;回答</label>
      <textarea
        class="form-control"
        id="answer-body"
        name="question-answer"
        v-model="questionAnswer.answer"
        :disabled="isProcessing"
      />
    </div>
    <div class="form-group clearfix">
      <div class="text-right">
        <button
          class="btn btn-success"
          id="save-answer-button"
          @click.prevent="handleSaveButtonClick"
          :disabled="isProcessing"
        >保存</button>
        <button
          class="btn btn-link"
          id="delete-answer-button"
          @click.prevent="handleDeleteButtonClick"
          :disabled="isProcessing"
        >
          <span class="text-danger">削除</span>
        </button>
      </div>
    </div>
  </div>
</div>
</template>