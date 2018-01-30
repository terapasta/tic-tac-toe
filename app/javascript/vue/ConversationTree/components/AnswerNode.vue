<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import includes from 'lodash/includes'
import classnames from 'classnames'

import AnswerIcon from './AnswerIcon'
import DecisionBranchNode from './DecisionBranchNode'
import { hasChildDecisionBranch } from '../helpers'
import NodeMixin from '../mixins/Node'
import HighlightTextMixin from '../mixins/HighlightText'

export default {
  name: 'answer-node',

  mixins: [NodeMixin, HighlightTextMixin],

  props: {
    node: { type: Object, default: () => ({}) }
  },

  data: () => ({
    routeName: 'Answer'
  }),

  components: {
    AnswerIcon,
    'decision-branch-node': DecisionBranchNode
  },

  mounted () {
    this.callOpenNodeIfNeeded(this.$route)
  },

  watch: {
    $route (to, from) {
      this.callOpenNodeIfNeeded(to)
    }
  },

  computed: {
    ...mapState([
      'questionsRepo',
      'openedNodes',
      'searchingKeyword'
    ]),

    hasChildren () {
      return !isEmpty(this.node.decisionBranches)
    },

    nodeData () {
      return this.questionsRepo[this.node.id]
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
    <router-link
      :class="itemClassName"
      :to="`/answer/${this.node.id}`"
      @click.native="handleClick"
    >
      <span class="tree__item-body">
        <answer-icon />
        <span v-html="highlight(nodeData.answer, searchingKeyword)" />
      </span>
    </router-link>
    <ol v-if="hasChildren" class="tree" :style="childTreeStyle">
      <template v-for="node in node.decisionBranches">
        <decision-branch-node :node="node" :key="node.id" />
      </template>
    </ol>
  </li>
</template>