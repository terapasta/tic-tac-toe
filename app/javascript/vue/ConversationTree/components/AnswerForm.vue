<script>
import { mapState, mapActions } from 'vuex'
import get from 'lodash/get'

import AnswerIcon from './AnswerIcon'
import DecisionBranchInlineForm from './DecisionBranchInlineForm'
import QuestionAnswerFormMixin from '../mixins/QuestionAnswerForm'
import AnswerFormMixin from '../mixins/AnswerForm'

export default {
  mixins: [
    QuestionAnswerFormMixin,
    AnswerFormMixin
  ],

  components: {
    AnswerIcon,
    DecisionBranchInlineForm
  },

  data: () => ({
    questionAnswer: {},
    decisionBranch: {},
    parent: {},
    node: {},
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
      'questionsTree',
      'decisionBranchesRepo'
    ]),

    decisionBranches () {
      const nodes = get(this, 'node.decisionBranches', [])
      return nodes.map(it => this.decisionBranchesRepo[it.id])
    },

    questionAnswerId () {
      if (this.$route.name === 'Answer') {
        return this.currentId
      }
    },

    decisionBranchId () {
      if (this.$route.name === 'DecisionBranch') {
        return this.currentId
      }
    }
  },

  methods: {
    ...mapActions([
      'updateQuestionAnswer',
      'deleteQuestionAnswer',
      'updateDecisionBranch',
      'deleteDecisionBranch',
      'addDecisionBranch'
    ]),

    handleSaveButtonClick () {
      const { body, answer } = this.decisionBranch
      switch (this.$route.name) {
        case 'Answer':
          this.saveQuestionAnswer()
          break
        case 'DecisionBranchAnswer':
          this.updateDecisionBranch({
            decisionBranchId: this.currentId,
            body,
            answer
          }).then(() => {
            toastr.success('選択肢を更新しました')
            this.isEditing = false
          }).catch(() => {
            toastr.error('選択肢を更新できませんでした', 'エラー')
          })
        default:
          break
      }
    }
  }
}
</script>

<template>
  <div>
    <div class="form-group">
      <label><answer-icon />&nbsp;回答</label>
      <textarea
        class="form-control"
        id="answer-body"
        name="answer-body"
        rows="3"
        style="height: 86px;"
        v-model="parent.answer"
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
        &nbsp;&nbsp;
        <button
          class="btn btn-link"
          id="delete-answer-button"
          @click.prevent="handleDeleteButtonClick"
          :disabled="isProcessing"
        ><span class="text-danger">削除</span></button>
      </div>
    </div>
    <div class="form-group">
      <ul v-if="decisionBranches.length > 0" class="list-group">
        <div v-for="data in decisionBranches" class="list-group-item" :key="(data || {}).id">
          <decision-branch-inline-form
            :questionAnswerId="questionAnswerId"
            :decisionBranchId="decisionBranchId"
            :nodeData="data"
          />
        </div>
      </ul>
      <button
        class="btn btn-link my-3"
        id="add-decision-branch-button"
        @click.prevent="handleAddDecisionBranchButtonClick"
        :disabled="isProcessing"
      >＋この回答に対する選択肢を追加する</button>
    </div>
  </div>
</template>