<script>
import { mapState } from 'vuex'
import isEmpty from 'is-empty'
import {
  chunk,
  range,
  includes,
  last,
  flatten,
  findIndex,
  findLastIndex,
  get,
  compact,
  reduce
 } from 'lodash'

import getOffset from '../helpers/getOffset'
import Tree from './ConversationTree/components/Tree'

const Direction = {
  Up: 'up',
  Down: 'down'
}

const calcPercentile = (offsetHeight, scrollHeight, scrollTop) => {
  if (scrollTop === 0) { return 0 }
  if (scrollTop + offsetHeight === scrollHeight) { return 1 }
  return (scrollTop + offsetHeight) / scrollHeight
}

export default {
  name: 'conversation-tree',

  components: {
    Tree
  },

  data: () => ({
    rootHeight: 0,
    currentNodes: [],
    showingIndecies: range(0, 30)
  }),

  mounted () {
    this.$nextTick(() => this.adjustHeight())
    window.addEventListener('resize', () => this.adjustHeight())
    this.updateCurrentNodes()
  },

  methods: {
    adjustHeight () {
      const offset = getOffset(this.$refs.root)
      const winHeight = window.innerHeight
      const height = winHeight - offset.top - 20
      this.rootHeight = height
    },

    handleMouseWheelMaster (e) {
      const { offsetHeight, scrollHeight, scrollTop } = this.$refs.master
      const direction = e.deltaY > 0 ? Direction.Down : Direction.Up
      const percentile = calcPercentile(offsetHeight, scrollHeight, scrollTop)
      this.lastScrollTop = scrollTop

      if (direction === Direction.Up && percentile < 0.3) {
        if (this.showingIndecies[0] !== 0) {
          const targetIndex = this.showingIndecies[0] - 1
          this.showingIndecies = [targetIndex].concat(this.showingIndecies)

          const hiddenComponents = this.$refs.tree.$children.filter((child, i) => {
            const rect = child.$el.getBoundingClientRect()
            const { top, height } = this.$refs.master.getBoundingClientRect()
            return rect.top > top + height
          })
          const hiddenIds = compact(hiddenComponents.map(it => get(it, 'node.id', null)))
          const hiddableIndecies = reduce(this.questionsTree, (acc, node, i) => {
            if (includes(hiddenIds, node.id)) { acc.push(i) }
            return acc
          }, [])
          this.showingIndecies = this.showingIndecies.filter(i => !includes(hiddableIndecies, i))
          this.updateCurrentNodes()
        }
      }

      if (direction === Direction.Down && percentile > 0.8) {
        if (last(this.showingIndecies) < this.questionsTree.length - 1) {
          this.showingIndecies = this.showingIndecies.concat([last(this.showingIndecies) + 1])

          const hiddenComponents = this.$refs.tree.$children.filter((child, i) => {
            const { top, height } = child.$el.getBoundingClientRect()
            return top + height < this.$refs.master.getBoundingClientRect().top
          })
          const hiddenIds = compact(hiddenComponents.map(it => get(it, 'node.id', null)))
          const hiddableIndecies = reduce(this.questionsTree, (acc, node, i) => {
            if (includes(hiddenIds, node.id)) { acc.push(i) }
            return acc
          }, [])
          this.showingIndecies = this.showingIndecies.filter(i => !includes(hiddableIndecies, i))
          this.updateCurrentNodes()
        }
      }
      // console.log(this.showingChunkIndecies, this.chunkedTree().length - 1)
    },

    chunkedTree () {
      return chunk(this.questionsTree, this.perPage)
    },

    updateCurrentNodes () {
      this.currentNodes = this.questionsTree.filter((_, i) => includes(this.showingIndecies, i))
    }
  },

  watch: {
    questionsTree () {
      this.updateCurrentNodes()
    }
  },

  computed: {
    ...mapState([
      'questionsTree'
    ]),

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
      <div
        class="master-detail-panel__master"
        @mousewheel="handleMouseWheelMaster"
        ref="master"
      >
        <tree
          :currentNodes="currentNodes"
          ref="tree"
        />
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
