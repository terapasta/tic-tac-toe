<script>
import { mapState } from 'vuex'

import QuestionNode from './SelectableTree/QuestionNode'

export default {
  components: {
    QuestionNode
  },

  props: {
    data: { type: Object, default: () => ({}) }
  },

  computed: {
    ...mapState([
      'questionsTree',
      'questionsRepo',
      'decisionBranchesRepo'
    ])
  }
}
</script>

<template>
  <div>
    <question-node
      v-for="node in questionsTree"
      :key="node.id"
      :node="node"
      :data="questionsRepo[node.id]"
      :subjectData="data"
    />
  </div>
</template>

<style scoped lang="scss">
</style>