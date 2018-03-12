<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import {
  range,
  includes,
  last,
  get,
  compact,
  reduce
 } from 'lodash'
import Multiselect from 'vue-multiselect'
import 'vue-multiselect/dist/vue-multiselect.min.css'

import getOffset from '../helpers/getOffset'
import { calcPercentile } from './ConversationTree/helpers'
import Tree from './ConversationTree/components/Tree'
import SearchForm from './ConversationTree/components/SearchForm'

const Direction = {
  Up: 'up',
  Down: 'down'
}

export default {
  name: 'conversation-tree',

  components: {
    Tree,
    SearchForm,
    Multiselect
  },

  data: () => ({
    rootHeight: 0,
    currentNodes: [],
    showingIndecies: range(0, 30),
    detailPanelHeight: null,
    detailPanelWatchTimer: null,
    originalDetailPanelHeight: null,
    selectedTopicTags: [],
    topicTags: [
      { id: 1, name: 'hoge' },
      { id: 2, name: 'fuga' }
    ]
  }),

  created () {
    this.toggleIsOnlyShowHasDecisionBranchesNode()
  },

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
    ...mapActions([
      'toggleIsOnlyShowHasDecisionBranchesNode'
    ]),

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

    // TODO: 大きいリストをスクロールしてもDOMの数が増えないコンポーネントとして分割したい
    handleMouseWheelMaster (e) {
      const { offsetHeight, scrollHeight, scrollTop } = this.$refs.master
      let direction
      if (isEmpty(e.deltaY)) {
        direction = e.wheelDelta < 0 ? Direction.Down : Direction.Up
      } else {
        direction = e.deltaY > 0 ? Direction.Down : Direction.Up
      }
      const percentile = calcPercentile(offsetHeight, scrollHeight, scrollTop)

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
          const hiddableIndecies = reduce(this.filteredQuestionsTree, (acc, node, i) => {
            if (includes(hiddenIds, node.id)) { acc.push(i) }
            return acc
          }, [])
          this.showingIndecies = this.showingIndecies.filter(i => !includes(hiddableIndecies, i))
          this.updateCurrentNodes()
        }
      }

      if (direction === Direction.Down && percentile > 0.8) {
        if (last(this.showingIndecies) < this.filteredQuestionsTree.length - 1) {
          this.showingIndecies = this.showingIndecies.concat([last(this.showingIndecies) + 1])

          const hiddenComponents = this.$refs.tree.$children.filter((child, i) => {
            const { top, height } = child.$el.getBoundingClientRect()
            return top + height < this.$refs.master.getBoundingClientRect().top
          })
          const hiddenIds = compact(hiddenComponents.map(it => get(it, 'node.id', null)))
          const hiddableIndecies = reduce(this.filteredQuestionsTree, (acc, node, i) => {
            if (includes(hiddenIds, node.id)) { acc.push(i) }
            return acc
          }, [])
          this.showingIndecies = this.showingIndecies.filter(i => !includes(hiddableIndecies, i))
          this.updateCurrentNodes()
        }
      }
    },

    updateCurrentNodes () {
      this.currentNodes = this.filteredQuestionsTree.filter((_, i) => includes(this.showingIndecies, i))
    },

    makeTopicTagLabel (option) {
      return option.name
    }
  },

  watch: {
    filteredQuestionsTree () {
      this.updateCurrentNodes()
    }
  },

  computed: {
    ...mapState([
      'questionsTree',
      'filteredQuestionsTree'
    ]),

    rootStyle () {
      return {
        height: `${this.rootHeight}px`
      }
    },

    detailPanelStyle () {
      return {
        maxHeight: this.detailPanelHeight ? `${this.detailPanelHeight}px` : 'auto',
        backgroundColor: this.$route.name === 'Home' ? 'rgba(255,255,255,.9)' : '#fff'
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
        @wheel="handleMouseWheelMaster"
        ref="master"
      >
        <search-form />
        <multiselect
          v-model="selectedTopicTags"
          :options="topicTags"
          :multiple="true"
          :custom-label="makeTopicTagLabel"
          :show-labels="false"
          placeholder="トピックタグで絞込み"
        />
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

<style lang="scss">
.tree {
  display: block;
}

.multiselect {
  margin-bottom: 8px;
  margin-left: 16px;
  width: calc(30% - 52px) !important;
}
.multiselect__content-wrapper {
  z-index: 100 !important;
}
.multiselect__tags {
  border-color: #ced4da !important;
  border-radius: 0.2rem !important;
}
.multiselect__tag,
.multiselect__option--highlight {
  background-color: #17a2b8 !important;
}
.multiselect__tag-icon:hover {
  background-color: darken(#17a2b8, 5%) !important;
}
</style>
