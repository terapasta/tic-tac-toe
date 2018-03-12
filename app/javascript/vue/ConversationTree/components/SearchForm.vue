<script>
import isEmpty from 'is-empty'
import { mapActions } from 'vuex'
import debounce from 'lodash/debounce'

export const Mode = {
  Global: 'global',
  Selectable: 'selectable'
}

export default {
  props: {
    mode: { type: String, default: Mode.Global }
  },

  data: () => ({
    keyword: '',
    isShowClearButton: false
  }),

  methods: {
    ...mapActions([
      'searchTree',
      'searchSelectableTree',
      'clearSearchTree',
      'clearSearchSelectableTree'
    ]),

    handleInputKeyUp: debounce(function (e) {
      const isKeywordExists = !isEmpty(e.target.value)
      this.isShowClearButton = isKeywordExists
      if (!isKeywordExists) {
        switch (this.mode) {
          case Mode.Global:
            return this.clearSearchTree()
          case Mode.Selectable:
            return this.clearSearchSelectableTree()
        }
      }
      switch (this.mode) {
        case Mode.Global:
          this.searchTree({ keyword: this.keyword })
          break
        case Mode.Selectable:
          this.searchSelectableTree({ keyword: this.keyword })
          break
      }
    }, 500),

    handleClearButtonClick () {
      switch (this.mode) {
        case Mode.Global:
          this.clearSearchTree()
          break
        case Mode.Selectable:
          this.clearSearchSelectableTree()
          break
      }
      this.isShowClearButton = false
      this.keyword = ''
    }
  },

  computed: {
    rootClassName () {
      switch (this.mode) {
        case Mode.Global:
          return 'master-detail-panel__search-container'
        case Mode.Selectable:
          return ''
      }
    }
  }
}
</script>

<template>
  <div :class="rootClassName">
    <div class="input-group btn-group">
      <input
        class="form-control form-control-sm input"
        type="search"
        placeholder="キーワード検索"
        v-model="keyword"
        @keyup="handleInputKeyUp"
      />
      <button
        v-if="isShowClearButton"
        class="input-group-append btn btn-secondary btn-sm"
        @click.prevent="handleClearButtonClick"
      >
        <div class="input-group-text">解除</div>
      </button>
    </div>
  </div>
</template>

<style scoped lang="scss">
.input {
  height: 40px;
}
</style>
