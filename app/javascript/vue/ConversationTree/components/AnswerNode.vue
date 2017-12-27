<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import includes from 'lodash/includes'
import classnames from 'classnames'

import AnswerIcon from './AnswerIcon'
import DecisionBranchNode from './DecisionBranchNode'
import { hasChildDecisionBranch } from '../helpers'
import NodeMixin from '../mixins/Node'

export default {
  name: 'answer-node',

  mixins: [NodeMixin],

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
      'openedNodes'
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
    <div :class="itemClassName">
      <router-link
        :to="`/answer/${this.node.id}`"
        class="tree__item-body"
        @click.native="handleClick"
      >
        <answer-icon />
        {{nodeData.answer}}
      </router-link>
    </div>
    <ol v-if="hasChildren" class="tree" :style="childTreeStyle">
      <template v-for="node in node.decisionBranches">
        <decision-branch-node :node="node" :key="node.id" />
      </template>
    </ol>
  </li>
</template>