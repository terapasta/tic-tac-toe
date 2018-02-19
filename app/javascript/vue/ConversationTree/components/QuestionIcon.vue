<script>
export default {
  name: 'question-icon',

  props: {
    hasDecisionBranches: { type: Boolean, default: false }
  }
}
</script>

<template>
  <span class="icon-wrapper">
    <i class="material-icons" title="質問">comment</i>
    <span class="icon-circle" v-if="hasDecisionBranches">
      <i class="material-icons upside-down" title="選択肢">call_split</i>
    </span>
  </span>
</template>