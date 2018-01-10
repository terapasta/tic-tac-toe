<script>
import classnames from 'classnames'

export default {
  props: {
    clickable: { type: Boolean, default: false },
    unclickable: { type: Boolean, default: false },
    selected: { type: Boolean, default: false }
  },

  computed: {
    className () {
      return classnames('card mb-3', {
        'clickable': this.clickable,
        'unclickable': this.unclickable,
        'selected': this.selected
      })
    },
  },

  methods: {
    handleClick () {
      if (this.clickable) {
        this.$emit('click')
      }

    }
  }
}
</script>

<template>
  <div :class="className" @click.prevent="handleClick">
    <div class="card-body p-2">
      <slot name="content" />
    </div>
  </div>
</template>
