<script>
import { mapState, mapActions } from 'vuex'
import toastr from 'toastr'

import AnswerIcon from './AnswerIcon'
import DecisionBranchIcon from './DecisionBranchIcon'

export default {
  components: {
    AnswerIcon,
    DecisionBranchIcon
  },

  data: () => ({
    questionAnswerId: null,
    decisionBranch: {}
  }),

  mounted () {
    this.setDecisionBranch()
  },

  watch: {
    $route () {
      this.setDecisionBranch()
    }
  },

  computed: {
    ...mapState([
      'questionsRepo',
      'decisionBranchesRepo'
    ]),

    currentId () {
      return window.parseInt(this.$route.params.id)
    }
  },

  methods: {
    ...mapActions([
      'updateDecisionBranch',
      'deleteDecisionBranch'
    ]),

    setDecisionBranch () {
      this.decisionBranch = this.decisionBranchesRepo[this.currentId]
    },

    handleSaveButtonClick () {
      const { id, body, answer } = this.decisionBranch
      this.updateDecisionBranch({
        decisionBranchId: id,
        body,
        answer
      }).then(() => {
        toastr.success('選択肢を更新しました')
        this.isEditing = false
      }).catch(() => {
        toastr.error('選択肢を更新できませんでした', 'エラー')
      })
    },

    handleDeleteButtonClick () {

    }
  }
}
</script>

<template>
  <div>
    <div class="form-group">
      <label><decision-branch-icon />&nbsp;現在の選択肢</label>
      <input
        type="text"
        class="form-control"
        v-model="decisionBranch.body"
      />
    </div>
    <div class="form-group">
      <label><answer-icon />&nbsp;回答</label>
      <textarea
        class="form-control"
        rows="3"
        v-model="decisionBranch.answer"
      ></textarea>
    </div>
    <div class="form-group text-right">
      <button
        class="btn btn-success"
        id="save-answer-button"
        @click.prevent="handleSaveButtonClick"
      >保存</button>
      &nbsp;&nbsp;
      <button
        class="btn btn-link"
        id="delete-answer-button"
        @click.prevent="handleDeleteButtonClick"
      ><span class="text-danger">削除</span></button>
    </div>
</div>
</template>