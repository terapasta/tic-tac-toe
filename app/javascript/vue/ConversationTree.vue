<script>
import getOffset from '../helpers/getOffset'
import Tree from './ConversationTree/components/Tree'

export default {
  name: 'conversation-tree',

  components: {
    Tree
  },

  data: () => ({
    rootHeight: 0
  }),

  mounted () {
    this.$nextTick(() => this.adjustHeight())
    window.addEventListener('resize', () => this.adjustHeight())
  },

  methods: {
    adjustHeight () {
      const offset = getOffset(this.$refs.root)
      const winHeight = window.innerHeight
      const height = winHeight - offset.top - 20
      this.rootHeight = height
    }
  },

  computed: {
    rootStyle () {
      return {
        height: `${this.rootHeight}px`
      }
    }
  }
}
</script>

<template>
  <div class="master-detail-panel" ref="root" :style="rootStyle">
    <div class="master-detail-panel__body">
      <div class="master-detail-panel__master">
        <tree />
      </div>
      <div class="master-detail-panel__detail">
        <router-view />
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.tree {
  display: block;
}
</style>
