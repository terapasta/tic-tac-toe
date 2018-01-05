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
      if (isEmpty(this.currentId)) {
        this.isNew = true
        this.questionAnswer = {}
        this.decisionBranch = {}
        return
      }
      switch (this.$route.name) {
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
    },

    saveQuestionAnswer () {
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
    }
  }
}