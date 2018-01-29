<script>
import { mapState } from 'vuex'
import isEmpty from 'is-empty'
import {
  range,
  includes,
  last,
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
    showingIndecies: range(0, 30),
    detailPanelHeight: null,
    detailPanelWatchTimer: null,
    originalDetailPanelHeight: null
  }),

  mounted () {
    this.$nextTick(() => {
      this.adjustHeight()
      this.adjustDetailPanelHeight()
    })
    window.addEventListener('resize', () => this.adjustHeight())
    this.detailPanelWatchTimer = setInterval(this.adjustDetailPanelHeight, 100)
    this.updateCurrentNodes()
  },

  beforeDestroy () {
    clearInterval(this.detailPanelWatchTimer)
  },

  methods: {
    adjustHeight () {
      const offset = getOffset(this.$refs.root)
      const winHeight = window.innerHeight
      const height = winHeight - offset.top - 20
      this.rootHeight = height
    },

    adjustDetailPanelHeight () {
      const maxHeight = this.rootHeight - 40
      this.detailPanelHeight = maxHeight
    },

    handleMouseWheelMaster (e) {
      const { offsetHeight, scrollHeight, scrollTop } = this.$refs.master
      let direction
      if (isEmpty(e.deltaY)) {
        direction = e.wheelDelta < 0 ? Direction.Down : Direction.Up
      } else {
        direction = e.deltaY > 0 ? Direction.Down : Direction.Up
      }
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
    },

    detailPanelStyle () {
      return {
        maxHeight: this.detailPanelHeight ? `${this.detailPanelHeight}px` : 'auto',
        backgroundColor: `${this.$route.name === 'Home' ? 'rgba(255,255,255,.9)' : '#fff'}`
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
      <div
        class="master-detail-panel__detail"
        :style="detailPanelStyle"
        ref="detailPanel"
      >
        <router-link class="master-detail-panel__close-detail" to="/" v-if="$route.name !== 'Home'">
          <i class="material-icons">close</i>
        </router-link>
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
