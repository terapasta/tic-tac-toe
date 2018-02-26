<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import get from 'lodash/get'
import toastr from 'toastr'

import Node from './Node'
import Item from './Item'
import DecisionBranchNode from './DecisionBranchNode'
import AnswerIcon from '../AnswerIcon'
import HighlightTextMixin from '../../mixins/HighlightText'

export default {
  mixins: [HighlightTextMixin],

  components: {
    Node,
    Item,
    DecisionBranchNode,
    AnswerIcon
  },

  props: {
    type: { type: String, default: "QuestionAnswer" },
    data: { type: Object, default: () => ({}) },
    node: { type: Object, default: () => ({}) },
    subjectData: { type: Object, default: () => ({}) }
  },

  computed: {
    ...mapState([
      'decisionBranchesRepo',
      'selectableTreeSearchingKeyword'
    ]),

    isSelected () {
      const db = this.decisionBranchesRepo[this.subjectData.id]
      if (isEmpty(db.answerLink)) { return false }
      const { answerRecordType, answerRecordId } = get(db, 'answerLink', {})
      return answerRecordType === this.type && answerRecordId === this.data.id
    },

    dbNodes () {
      const { decisionBranches, childDecisionBranches } = this.node
      return decisionBranches || childDecisionBranches || []
    },

    isClickable () {
      const db = this.decisionBranchesRepo[this.subjectData.id]
      switch (this.type) {
        case 'QuestionAnswer':
          return true
        case 'DecisionBranch':
          return db.id !== this.data.id
      }
    },

    text () {
      const text = this.highlight(this.data.answer, this.selectableTreeSearchingKeyword)
      return text.replace(/\n/g, '<br />')
    }
  },

  methods: {
    ...mapActions([
      'selectAnswerLink',
      'deselectAnswerLink',
      'updateDecisionBranch'
    ]),

    handleItemClick () {
      const db = this.decisionBranchesRepo[this.subjectData.id]
      const action = this.isSelected ? 'deselectAnswerLink' : 'selectAnswerLink'
      Promise.all([
        this[action]({
          decisionBranchId: db.id,
          answerRecordType: this.type,
          answerRecordId: this.data.id
        }),
        this.updateDecisionBranch({
          decisionBranchId: db.id,
          body: db.body,
          answer: ''
        })
      ]).then(() => {
        toastr.success('選択肢の回答をリンクしました')
      }).catch(console.error)
    },

    getDBData (id) {
      return this.decisionBranchesRepo[id]
    }
  }
}
</script>

<template>
  <node :indent="true">
    <span slot="content">
      <item
        :clickable="isClickable"
        :unclickable="!isClickable"
        :selected="isSelected"
        @click="handleItemClick"
      >
        <span slot="content">
          <answer-icon />
          <span v-html="text" />
        </span>
      </item>
      <decision-branch-node
        v-for="node in dbNodes"
        :key="node.id"
        :data="getDBData(node.id)"
        :node="node"
        :subjectData="subjectData"
      />
    </span>
  </node>
</template>

<style scoped lang="scss">
</style>