<script>
import { mapState } from 'vuex'

import QuestionNode from './SelectableTree/QuestionNode'

export default {
  components: {
    QuestionNode
  },

  props: {
    data: { type: Object, default: () => ({}) },
    filteredQuestionsTree: { type: Array, required: true }
  },

  computed: {
    ...mapState([
      'questionsRepo',
      'decisionBranchesRepo'
    ])
  }
}
</script>

<template>
  <div class="selectableTree">
    <question-node
      v-for="node in filteredQuestionsTree"
      :key="node.id"
      :node="node"
      :data="questionsRepo[node.id]"
      :subjectData="data"
    />
  </div>
</template>

<style scoped lang="scss">
</style>