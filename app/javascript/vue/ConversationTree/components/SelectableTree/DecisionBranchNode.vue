<script>
import { mapState } from 'vuex'

import Node from './Node'
import Item from './Item'
import DecisionBranchIcon from '../DecisionBranchIcon'

export default {
  components: {
    Node,
    Item,
    DecisionBranchIcon
  },

  props: {
    data: { type: Object, default: () => ({}) },
    node: { type: Object, default: () => ({}) },
    subjectData: { type: Object, default: () => ({}) }
  },

  // data () {
  //   return {
  //     _subjectData: this.subjectData
  //   }
  // },

  beforeCreate () {
    const AnswerNode = require('./AnswerNode').default
    this.$options.components.AnswerNode = AnswerNode
  },

  computed: {
    ...mapState([
      'decisionBranchesRepo'
    ]),

    isSelf () {
      return this.data.id === this.subjectData.id
    },

    text () {
      return this.data.body.replace(/\n/g, '<br />')
    }
  }
}
</script>

<template>
  <node :indent="true">
    <span slot="content">
      <item :unclickable="true">
        <span slot="content">
          <decision-branch-icon />
          <span v-html="text" />
          <span v-if="isSelf">
            <br />
            <small>現在の選択肢</small>
          </span>
        </span>
      </item>
      <answer-node
        v-if="data.answer"
        type="DecisionBranch"
        :data="data"
        :node="node"
        :subjectData="subjectData"
      />
    </span>
  </node>
</template>

<style scoped lang="scss">
</style>