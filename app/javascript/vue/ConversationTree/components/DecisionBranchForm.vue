<script>
import { mapState, mapActions } from 'vuex'
import toastr from 'toastr'
import isEmpty from 'is-empty'

import DecisionBranchFormMixin from '../mixins/DecisionBranchForm'

import AnswerIcon from './AnswerIcon'
import DecisionBranchIcon from './DecisionBranchIcon'
import AnswerTab, { TabType } from './DecisionBranchAnswerTab'
import SelectableTree from './SelectableTree'

export default {
  mixins: [DecisionBranchFormMixin],

  components: {
    AnswerIcon,
    DecisionBranchIcon,
    AnswerTab,
    SelectableTree
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
      'decisionBranchesRepo',
      'questionsTree'
    ]),

    currentId () {
      return window.parseInt(this.$route.params.id)
    },

    nodeData () {
      return this.decisionBranchesRepo[this.currentId]
    },

    decisionBranchId () {
      return this.currentId
    },

    tabType () {
      return isEmpty(this.nodeData.answerLink) ? TabType.Input : TabType.Select
    }
  },

  methods: {
    ...mapActions([
      'updateDecisionBranch',
      'deleteDecisionBranch',
      'deselectAnswerLink'
    ]),

    setDecisionBranch () {
      this.decisionBranch = this.decisionBranchesRepo[this.currentId]
    },

    handleSaveButtonClick () {
      const { id, body, answer } = this.decisionBranch
      let promises = []

      if (!isEmpty(answer)) {
        promises.push(this.deselectAnswerLink({ decisionBranchId: this.currentId }))
      }

      promises.push(this.updateDecisionBranch({
        decisionBranchId: id,
        body,
        answer
      }))

      Promise.all(promises)
        .then(() => {
          toastr.success('選択肢を更新しました')
          this.isEditing = false
        }).catch(() => {
          toastr.error('選択肢を更新できませんでした', 'エラー')
        })
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
      <answer-tab :tabType="tabType">
        <textarea
          class="form-control"
          rows="3"
          v-model="decisionBranch.answer"
          slot="input"
        ></textarea>
        <div slot="select">
          <p>この選択肢から別のQ&Aツリーの回答にリンクさせることができます</p>
          <selectable-tree
            :data="decisionBranch"
          />
        </div>
      </answer-tab>
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