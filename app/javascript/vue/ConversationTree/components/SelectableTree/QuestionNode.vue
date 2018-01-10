<script>
import Node from './Node'
import Item from './Item'
import AnswerNode from './AnswerNode'
import QuestionIcon from '../QuestionIcon'

export default {
  components: {
    Node,
    Item,
    AnswerNode,
    QuestionIcon
  },

  props: {
    data: { type: Object, default: () => ({}) },
    node: { type: Object, default: () => ({}) },
    subjectData: { type: Object, default: () => ({}) }
  },

  computed: {
    text () {
      return this.data.question.replace(/\n/g, '<br />')
    }
  }
}
</script>

<template>
  <node>
    <span slot="content">
      <item :unclickable="true">
        <span slot="content">
          <question-icon />
          <span v-html="text" />
        </span>
      </item>
      <answer-node
        type="QuestionAnswer"
        :data="data"
        :node="node"
        :subjectData="subjectData"
      />
    </span>
  </node>
</template>

<style scoped lang="scss">
</style>