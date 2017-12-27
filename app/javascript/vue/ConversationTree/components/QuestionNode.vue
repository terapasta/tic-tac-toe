<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import includes from 'lodash/includes'
import classnames from 'classnames'

import QuestionIcon from './QuestionIcon'
import AnswerNode from './AnswerNode'
import { hasChildDecisionBranch } from '../helpers'
import NodeMixin from '../mixins/Node'

export default {
  name: 'question-node',

  mixins: [NodeMixin],

  props: {
    node: { type: Object, default: () => ({}) }
  },

  data: () => ({
    routeName: 'Question',
  }),

  components: {
    QuestionIcon,
    AnswerNode
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
      return !isEmpty(this.nodeData.answer)
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
      'openNode',
      'closeNode',
    ])
  }
}
</script>

<template>
  <li class="tree__node" :id="nodeId">
    <div :class="itemClassName">
      <router-link
        :to="`/question/${this.node.id}`"
        class="tree__item-body"
        @click.native="handleClick"
      >
        <question-icon />
        {{nodeData.question}}
      </router-link>
    </div>
    <ol class="tree" v-if="hasChildren" :style="childTreeStyle">
      <answer-node :node="node" />
    </ol>
  </li>
</template>