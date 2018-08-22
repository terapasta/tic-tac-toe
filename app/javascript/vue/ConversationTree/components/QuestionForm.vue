<script>
import { mapState, mapActions, mapMutations } from 'vuex'
import isEmpty from 'is-empty'
import toastr from 'toastr'
import get from 'lodash/get'

import QuestionIcon from './QuestionIcon'
import AnswerIcon from './AnswerIcon'
import AnswerFiles from './AnswerFiles'
import QuestionAnswerFormMixin from '../mixins/QuestionAnswerForm'
import { UPDATE_QUESTION_ANSWER } from '../store/mutationTypes'
import AnswerTextArea from '../../AnswerTextArea'

export default {
  mixins: [
    QuestionAnswerFormMixin
  ],

  components: {
    QuestionIcon,
    AnswerIcon,
    AnswerFiles,
    AnswerTextArea
  },

  data: () => ({
    questionAnswer: {},
    isNew: false,
    isProcessing: false,
    isCreatingSubQuestion: false,
    creatingSubQuestion: ''
  }),

  created () {
    this.$root.$on('updatedQuestionAnswers', () => {
      this.setParent()
    })
  },

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
      'questionsTree',
      'isStaff'
    ]),

    isNeedZendeskAlert () {
      return get(this, 'questionAnswer.zendeskArticleId') && this.isStaff
    }
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
    ...mapMutations({
      updateQuestionAnswerMutation: UPDATE_QUESTION_ANSWER
    }),

    handleDeleteSubQuestionButtonClick (e) {
      this.$swal({
        title: '本当に削除してよろしいですか？',
        text: 'この操作は取り消せません。',
        type: 'warning',
        showCancelButton: true
      }).then(() => {
        this.isProcessing = true
        const index = window.parseInt(e.target.getAttribute('data-index'))
        const subQuestion = get(this, `questionAnswer.subQuestions[${index}]`, null)
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
    },

    handleAnswerKeyup (answer) {
      this.questionAnswer.answer = answer
      this.updateQuestionAnswerMutation({
        questionAnswer: this.questionAnswer,
        id: this.currentId
      })
      // const { questionAnswer } = this
      // this.updateQuestionAnswerMutation({ questionAnswer, id: this.currentId })
    }
  }
}
</script>

<template>
  <div>
    <div class="form-group">
      <div v-if="isNeedZendeskAlert" class="card border-success mb-3">
        <div class="card-body p-2 d-flex justify-content-between align-items-center">
          <span>このQ&AはZendeskで管理されています</span>
          <span class="badge badge-success">STAFF ONLY</span>
        </div>
      </div>
      <label><question-icon />&nbsp;質問</label>
      <textarea
        id="question"
        name="question-question"
        class="form-control mb-3"
        placeholder="質問を入力してください（例：カードキー無くしてしまったのですが、どうすればいいですか）"
        v-if="questionAnswer"
        v-model="questionAnswer.question"
        :disabled="isProcessing"
      />
      <div class="card">
        <div class="card-body p-3">
          <label>
            <span class="pr-2">サブ質問</span>
            <small>言い方の違う質問文を登録すると、回答精度の向上が期待できます</small>
          </label>
          <div v-for="(sq, i) in ((questionAnswer || {}).subQuestions || [])" class="mb-3" :key="sq.id">
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
    <answer-text-area
      name="question-answer"
      v-if="questionAnswer"
      :default-value="questionAnswer.answer"
      :disabled="isProcessing"
      @keyup="handleAnswerKeyup"
    />
    <answer-files
      v-if="(questionAnswer || {}).id"
      :questionAnswerId="questionAnswer.id"
      :answerFiles="questionAnswer.answerFiles"
    />
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