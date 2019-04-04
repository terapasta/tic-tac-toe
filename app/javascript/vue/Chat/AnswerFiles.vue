<script>
import AnswerFile from './AnswerFile'

export default {
  components: {
    AnswerFile,
  },

  props: {
    answerFiles: { type: Array, required: true },
  },

  data: () => ({
    wrapperStyle: {},
  }),

  created () {
    window.addEventListener('resize', this.handleWindowResize)
  },

  mounted () {
    this.$nextTick(() => {
      this.updateWrapperStyle()
    })
  },

  beforeDestroy  () {
    window.removeEventListener('resize', this.handleWindowResize)
  },

  methods: {
    handleWindowResize () {
      this.updateWrapperStyle()
    },

    updateWrapperStyle () {
      const { container, wrapper } = this.$refs
      const { left } = container.getBoundingClientRect()
      const paddingLeft = parseInt(getComputedStyle(container)['padding-left'].replace('px', ''))
      wrapper.scrollTo(0, 0)
      this.wrapperStyle = {
        ...this.wrapperStyle,
        width: `${window.innerWidth}px`,
        marginLeft: `-${left + paddingLeft}px`,
        paddingLeft: `${left + paddingLeft}px`,
        paddingRight: '16px',
      }
    }
  }
}
</script>

<template>
  <div class="container" ref="container">
    <div class="wrapper" ref="wrapper" :style="wrapperStyle">
      <answer-file
        v-for="(answerFile, i) in answerFiles"
        :key="i"
        :answer-file="answerFile"
      />
    </div>
  </div>
</template>

<style lang="scss" scoped>
.wrapper {
  padding-top: 16px;
  white-space: nowrap;
  overflow-x: auto;
}
</style>
