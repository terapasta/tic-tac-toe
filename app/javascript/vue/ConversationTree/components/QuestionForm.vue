<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'

import QuestionIcon from './QuestionIcon'
import AnswerIcon from './AnswerIcon'

export default {
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
    this.setQuestionAnswer()
  },

  watch: {
    $route () {
      this.setQuestionAnswer()
    }
  },

  computed: {
    ...mapState([
      'questionsRepo'
    ])
  },

  methods: {
    ...mapActions([
      'createQuestionAnswer',
      'updateQuestionAnswer',
      'deleteQuestionAnswer'
    ]),

    setQuestionAnswer () {
      const { id } = this.$route.params
      if (isEmpty(id)) {
        this.isNew = true
        this.questionAnswer = {}
        return
      }
      this.questionAnswer = this.questionsRepo[window.parseInt(id)]
    },

    handleSaveButtonClick () {
      const { id, question, answer } = this.questionAnswer
      this.isProcessing = true
      const verb = this.isNew ? 'create' : 'update'
      this[`${verb}QuestionAnswer`]({ id, question, answer })
        .then(newQuestionAnswer => {
          this.isNew = false
          this.isProcessing = false
          this.$router.push(`/question/${newQuestionAnswer.id}`)
        })
        .catch(() => this.$swal({
          title: 'エラー',
          text: '保存ができませんでした',
          type: 'error'
        }))
    },

    handleDeleteButtonClick () {
      const { id } = this.questionAnswer
      this.$swal({
        title: '本当に削除してよろしいですか？',
        text: 'この操作は取り消せません。配下の回答や選択肢も削除されます。',
        type: 'warning',
        showCancelButton: true
      }).then(() => {
        this.deleteQuestionAnswer({ id })
          .then(() => this.$router.push('/'))
          .catch(() => this.$swal({
            title: 'エラー',
            text: '削除ができませんでした',
            type: 'error'
          }))
      }).catch(this.$swal.noop)
    }
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