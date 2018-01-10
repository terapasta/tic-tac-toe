<script>
import NodeMixin from '../mixins/Node'
import AnswerIcon from './AnswerIcon'
import LinkIcon from './LinkIcon'

export default {
  mixins: [NodeMixin],

  components: {
    AnswerIcon,
    LinkIcon
  },

  props: {
    answerLink: { type: Object, default: () => ({}) }
  },

  computed: {
    nodeId () {
      return this.answerLink.ansewrRecordId
    },

    linkUrl () {
      const { answerRecordType, answerRecordId } = this.answerLink
      const type = answerRecordType === 'QuestionAnswer' ?
        'answer' : 'decisionBranchAnswer'
      return `/${type}/${answerRecordId}`
    },

    isActive () {
      const { answerRecordType, answerRecordId } = this.answerLink
      const { name, params: { id } } = this.$route
      const intId = window.parseInt(id)
      const isActiveA = answerRecordType === 'QuestionAnswer' &&
        name === 'Answer' && intId === answerRecordId
      const isActiveDB = answerRecordType === 'DecisionBranch' &&
        name === 'DecisionBranchAnswer' && intId === answerRecordId
      return isActiveA || isActiveDB
    }
  }
}
</script>

<template>
  <li class="tree__node" :id="nodeId">
    <router-link
      :to="linkUrl"
      :class="itemClassName"
    >
      <span class="tree__item-body">
        <answer-icon />
        <link-icon />
        回答リンク
      </span>
    </router-link>
  </li>
</template>