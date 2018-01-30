<script>
import isEmpty from 'is-empty'
import { mapActions } from 'vuex'
import debounce from 'lodash/debounce'

export default {
  data: () => ({
    keyword: '',
    isShowClearButton: false
  }),

  methods: {
    ...mapActions(['searchTree', 'clearSearchTree']),

    handleInputKeyUp: debounce(function (e) {
      const isKeywordExists = !isEmpty(e.target.value)
      this.isShowClearButton = isKeywordExists
      if (!isKeywordExists) { return this.clearSearchTree() }
      this.searchTree({ keyword: this.keyword })
    }, 500),

    handleClearButtonClick () {
      this.clearSearchTree()
      this.isShowClearButton = false
      this.keyword = ''
    }
  }
}
</script>

<template>
  <div class="master-detail-panel__search-container">
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
