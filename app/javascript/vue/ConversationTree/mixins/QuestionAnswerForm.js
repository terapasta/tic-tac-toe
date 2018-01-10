import isNaN from 'lodash/isNaN'
import get from 'lodash/get'
import isEmpty from 'is-empty'

import {
  findQuestionAnswerFromTree,
  findDecisionBranchFromTree
} from '../helpers'

export default {
  computed: {
    currentId () {
      return window.parseInt(this.$route.params.id)
    }
  },

  methods: {
    setParent () {
      if (isEmpty(this.currentId) || isNaN(this.currentId)) {
        this.isNew = true
        this.questionAnswer = {}
        this.decisionBranch = {}
        return
      }
      switch (this.$route.name) {
        case 'Question':
        case 'Answer':
          this.parent = this.questionAnswer = this.questionsRepo[this.currentId]
          this.node = findQuestionAnswerFromTree(this.questionsTree, this.currentId)
          break
        case 'DecisionBranchAnswer':
          this.parent = this.decisionBranch = this.decisionBranchesRepo[this.currentId]
          findDecisionBranchFromTree(this.questionsTree, this.currentId, (node) => {
            this.node = node
          })
          break
        default:
          break
      }
    },

    handleSaveButtonClick () {
      this.saveQuestionAnswer()
    },

    handleDeleteButtonClick () {
      const { id, question } = this.questionAnswer
      const body = get(this, "decisionBranch.body")
      const errorHandler = () => this.$swal({
        title: 'エラー',
        text: '削除ができませんでした',
        type: 'error'
      })
      this.$swal({
        title: '本当に削除してよろしいですか？',
        text: 'この操作は取り消せません。配下の回答や選択肢も削除されます。',
        type: 'warning',
        showCancelButton: true
      }).then(() => {
        switch (this.$route.name) {
          case "Question":
            this.deleteQuestionAnswer({ id })
              .then(() => this.$router.push('/'))
              .catch(errorHandler)
            break
          case "Answer":
            this.updateQuestionAnswer({ id, question, answer: "" })
              .then(() => this.$router.push(`/question/${id}`))
              .catch(errorHandler)
            break
          case "DecisionBranchAnswer":
            this.updateDecisionBranch({
              decisionBranchId: this.currentId,
              body,
              answer: ""
            }).then(() => this.$router.push(`/decisionBranch/${this.currentId}`))
              .catch(errorHandler)
            break
          default:
            break
        }
      }).catch(this.$swal.noop)
    },

    saveQuestionAnswer () {
      const { id, question, answer } = this.questionAnswer
      this.isProcessing = true
      const verb = this.isNew ? 'create' : 'update'
      this[`${verb}QuestionAnswer`]({ id, question, answer })
        .then(newQuestionAnswer => {
          console.log(newQuestionAnswer)
          this.isNew = false
          this.isProcessing = false
          this.$router.push(`/question/${newQuestionAnswer.id}`)
        })
        .catch(() => this.$swal({
          title: 'エラー',
          text: '保存ができませんでした',
          type: 'error'
        }))
    }
  }
}