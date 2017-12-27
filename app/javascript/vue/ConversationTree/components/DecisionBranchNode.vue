<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import includes from 'lodash/includes'
import classnames from 'classnames'

import DecisionBranchIcon from './DecisionBranchIcon'
import DecisionBranchAnswerNode from './DecisionBranchAnswerNode'
import NodeMixin from '../mixins/Node'

export default {
  mixins: [NodeMixin],

  props: {
    node: { type: Object, default: () => ({}) }
  },

  data: () => ({
    routeName: 'DecisionBranch'
  }),

  components: {
    DecisionBranchIcon,
    DecisionBranchAnswerNode
  },

  mounted () {
    this.callOpenNodeIfNeeded(this.$route)
  },

  watch: {
    $route (to) {
      this.callOpenNodeIfNeeded(to)
    }
  },

  computed: {
    ...mapState([
      'decisionBranchesRepo',
      'openedNodes'
    ]),

    hasChildren () {
      return !isEmpty(this.nodeData.answer)
    },

    nodeData () {
      return this.decisionBranchesRepo[this.node.id]
    },

    isOpened () {
      return this.isStoredOpenedNodes || this.currentPageIsChild
    }
  },

  methods: {
    ...mapActions([
      'closeNode',
      'openNode'
    ])
  }
}
</script>

<template>
  <li class="tree__node" :id="nodeId">
    <div :class="itemClassName">
      <router-link
        :to="`/decisionBranch/${this.node.id}`"
        class="tree__item-body"
        @click.native="handleClick"
      >
        <decision-branch-icon />
        {{nodeData.body}}
      </router-link>
    </div>
    <ol class="tree" v-if="hasChildren" :style="childTreeStyle">
      <decision-branch-answer-node :node="node" />
    </ol>
  </li>
</teamplte>