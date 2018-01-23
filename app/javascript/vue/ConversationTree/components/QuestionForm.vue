<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import toastr from 'toastr'

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
    isProcessing: false,
    isCreatingSubQuestion: false,
    creatingSubQuestion: ''
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
      'deleteQuestionAnswer',
      'createSubQuestion',
      'updateSubQuestion',
      'deleteSubQuestion'
    ]),

    handleDeleteSubQuestionButtonClick (e) {
      this.$swal({
        title: '本当に削除してよろしいですか？',
        text: 'この操作は取り消せません。',
        type: 'warning',
        showCancelButton: true
      }).then(() => {
        this.isProcessing = true
        const index = window.parseInt(e.target.getAttribute('data-index'))
        const subQuestion = this.questionAnswer.subQuestions[index]
        if (isEmpty(subQuestion)) { return }
        this.deleteSubQuestion({
          questionAnswerId: this.questionAnswer.id,
          subQuestionId: subQuestion.id
        }).then(() => {
          this.isProcessing = false
          toastr.success('サブ質問を削除しました')
        }).catch(() => {
          this.isProcessing = false
          this.$swal({
            title: 'エラー',
            text: '削除ができませんでした',
            type: 'error'
          })
        })
      }).catch(this.$swal.noop)
    },

    handleAddSubQuestionButtonClick () {
      this.isCreatingSubQuestion = true
    },

    handleCancelAddSubQuestionButtonClick () {
      this.isCreatingSubQuestion = false
    },

    handleSaveAddSubQuestionButtonClick () {
      if (isEmpty(this.creatingSubQuestion)) { return }
      this.isProcessing = true
      this.createSubQuestion({
        questionAnswerId: this.questionAnswer.id,
        question: this.creatingSubQuestion
      }).then(() => {
        this.isProcessing = false
        this.isCreatingSubQuestion = false
        this.creatingSubQuestion = ''
        toastr.success('サブ質問を作成しました')
      }).catch(() => {
        this.isProcessing = false
        this.$swal({
          title: 'エラー',
          text: '削除ができませんでした',
          type: 'error'
        })
      })
    },

    handleUpdateSubQuestionButtonClick (e) {
      const index = window.parseInt(e.target.getAttribute('data-index'))
      const subQuestion = this.questionAnswer.subQuestions[index]
      if (isEmpty(subQuestion)) { return }
      this.isProcessing = true
      this.updateSubQuestion({
        questionAnswerId: this.questionAnswer.id,
        subQuestionId: subQuestion.id,
        question: subQuestion.question
      }).then(() => {
        this.isProcessing = false
        toastr.success('サブ質問を更新しました')
      }).catch(() => {
        this.isProcessing = false
        this.$swal({
          title: 'エラー',
          text: '更新ができませんでした',
          type: 'error'
        })
      })
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
        class="form-control mb-3"
        placeholder="質問を入力してください（例：カードキー無くしてしまったのですが、どうすればいいですか）"
        v-model="questionAnswer.question"
        :disabled="isProcessing"
      />
      <div class="card">
        <div class="card-body p-3">
          <label>
            <span class="pr-2">サブ質問</span>
            <small>言い方の違う質問文を登録すると、回答精度の向上が期待できます</small>
          </label>
          <div v-for="(sq, i) in questionAnswer.subQuestions" class="mb-3" :key="sq.id">
            <textarea
              v-model="sq.question"
              class="form-control mb-1"
              :disabled="isProcessing"
            />
            <div class="text-right">
              <button
                class="btn btn-success btn-sm"
                :data-index="i"
                @click.prevent="handleUpdateSubQuestionButtonClick"
                :disabled="isProcessing"
              >更新</button>
              &nbsp;&nbsp;
              <button
                class="btn btn-danger btn-sm"
                :data-index="i"
                @click.prevent="handleDeleteSubQuestionButtonClick"
                :disabled="isProcessing"
              >削除</button>
            </div>
          </div>
          <div>
            <textarea
              v-if="isCreatingSubQuestion"
              class="form-control mb-1"
              v-model="creatingSubQuestion"
              autofocus
              :disabled="isProcessing"
            />
            <div class="justify-content-between d-flex">
              <button
                v-if="!isCreatingSubQuestion"
                class="btn btn-secondary btn-sm"
                @click.prevent="handleAddSubQuestionButtonClick"
                :disabled="isProcessing"
              >サブ質問を追加</button>
              <button
                v-if="isCreatingSubQuestion"
                class="btn btn-link btn-sm"
                @click.prevent="handleCancelAddSubQuestionButtonClick"
                :disabled="isProcessing"
              >キャンセル</button>
              <button
                v-if="isCreatingSubQuestion"
                class="btn btn-success btn-sm"
                @click.prevent="handleSaveAddSubQuestionButtonClick"
                :disabled="isProcessing"
              >保存</button>
            </div>
          </div>
        </div>
      </div>
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