<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import includes from 'lodash/includes'

import AnswerIcon from './AnswerIcon'
import NodeMixin from '../mixins/Node'

export default {
  mixins: [NodeMixin],

  props: {
    node: { type: Object, default: () => ({}) }
  },

  data: () => ({
    routeName: 'DecisionBranchAnswer',
    nodeData: {}
  }),

  components: {
    AnswerIcon,
  },

  // DecisionBranchNodeとこのファイルで循環参照が起きるためこのフックで読み込むようにすると解決される
  beforeCreate () {
    const comp = require('./DecisionBranchNode').default
    this.$options.components.DecisionBranchNode = comp
  },

  mounted () {
    this.callOpenNodeIfNeeded(this.$route)
    this.nodeData = this.decisionBranchesRepo[this.node.id]
  },

  watch: {
    $route (to) {
      this.callOpenNodeIfNeeded(to)
      this.nodeData = this.decisionBranchesRepo[this.node.id]
    }
  },

  computed: {
    ...mapState([
      'decisionBranchesRepo',
      'openedNodes'
    ]),

    hasChildren () {
      return !isEmpty(this.node.childDecisionBranches)
    },

    // nodeData () {
    //   return this.decisionBranchesRepo[this.node.id]
    // },

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
    <router-link
      :class="itemClassName"
      :to="`/decisionBranchAnswer/${this.node.id}`"
      @click.native="handleClick"
    >
      <span class="tree__item-body">
        <answer-icon />
        {{nodeData.answer}}
      </span>
    </router-link>
    <ol v-if="hasChildren" class="tree" :style="childTreeStyle">
      <template v-for="node in node.childDecisionBranches">
        <decision-branch-node :node="node" :key="node.id" />
      </template>
    </ol>
  </li>
</template>