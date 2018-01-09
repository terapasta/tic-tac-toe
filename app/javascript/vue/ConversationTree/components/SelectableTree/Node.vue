<script>
export default {
  props: {
    indent: { type: Boolean, default: false }
  },

  computed: {
    style () {
      return `
        ${this.indent && 'margin-left: 24px;'}
      `
    }
  }
}
</script>

<template>
  <div class="mb-3" :style="style">
    <slot name="content" />
  </div>
</template>

<style scoped lang="scss">
</style>
