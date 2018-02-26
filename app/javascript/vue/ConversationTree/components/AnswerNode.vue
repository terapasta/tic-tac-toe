<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import includes from 'lodash/includes'
import map from 'lodash/map'
import sortBy from 'lodash/sortBy'
import compact from 'lodash/compact'
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
      'searchingKeyword',
      'decisionBranchesRepo'
    ]),

    hasChildren () {
      return !isEmpty(this.node.decisionBranches)
    },

    nodeData () {
      return this.questionsRepo[this.node.id]
    },

    isOpened () {
      return this.isStoredOpenedNodes || this.currentPageIsChild
    },

    orderedDecisionBranches () {
      const dbIds = compact(map(this.node.decisionBranches, (it) => it.id))
      const dbs = dbIds.map(it => this.decisionBranchesRepo[it])
      const sortedDbs = sortBy(dbs, ['position'])
      const copy = this.node.decisionBranches.concat()
      const ordered = sortedDbs.map(it => copy.filter(nit => nit.id === it.id)[0])
      return ordered
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
      <template v-for="node in orderedDecisionBranches">
        <decision-branch-node :node="node" :key="node.id" />
      </template>
    </ol>
  </li>
</template>