<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import includes from 'lodash/includes'
import classnames from 'classnames'

import DecisionBranchIcon from './DecisionBranchIcon'
import DecisionBranchAnswerNode from './DecisionBranchAnswerNode'
import AnswerLinkNode from './AnswerLinkNode'
import NodeMixin from '../mixins/Node'
import HighlightTextMixin from '../mixins/HighlightText'

export default {
  mixins: [NodeMixin, HighlightTextMixin],

  props: {
    node: { type: Object, default: () => ({}) }
  },

  data: () => ({
    routeName: 'DecisionBranch',
    nodeData: {}
  }),

  components: {
    DecisionBranchIcon,
    DecisionBranchAnswerNode,
    AnswerLinkNode
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
      'openedNodes',
      'searchingKeyword'
    ]),

    hasChildren () {
      if (this.isNew) { return false }
      return this.hasAnswer || this.hasAnswerLink
    },

    hasAnswer () {
      return !isEmpty(this.nodeData.answer) && !this.hasAnswerLink
    },

    hasAnswerLink () {
      return !isEmpty(this.nodeData.answerLink)
    },

    isOpened () {
      return this.isStoredOpenedNodes || this.currentPageIsChild
    },

    isNew () {
      return isEmpty(this.nodeData)
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
    <template v-if="!isNew">
      <router-link
        :class="itemClassName"
        :to="`/decisionBranch/${this.node.id}`"
        @click.native="handleClick"
      >
        <span class="tree__item-body">
          <decision-branch-icon />
          <span v-html="highlight(nodeData.body, searchingKeyword)" />
        </span>
      </router-link>
      <ol class="tree" v-if="hasChildren" :style="childTreeStyle">
        <decision-branch-answer-node v-if="hasAnswer" :node="node" />
        <answer-link-node v-if="hasAnswerLink" :answerLink="nodeData.answerLink" />
      </ol>
    </template>
  </li>
</teamplte>