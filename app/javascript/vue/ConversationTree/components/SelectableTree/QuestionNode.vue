<script>
import { mapState } from 'vuex'

import Node from './Node'
import Item from './Item'
import AnswerNode from './AnswerNode'
import QuestionIcon from '../QuestionIcon'
import HighlightTextMixin from '../../mixins/HighlightText'

export default {
  mixins: [HighlightTextMixin],

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
    ...mapState(['selectableTreeSearchingKeyword']),

    text () {
      const text = this.highlight(this.data.question, this.selectableTreeSearchingKeyword)
      return text.replace(/\n/g, '<br />')
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