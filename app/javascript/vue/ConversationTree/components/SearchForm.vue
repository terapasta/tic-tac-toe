<script>
import isEmpty from 'is-empty'

export default {
  data: () => ({
    keyword: '',
    isShowClearButton: false
  }),

  methods: {
    handleInputKeyUp (e) {
      this.isShowClearButton = !isEmpty(e.target.value)
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
      >
        <div class="input-group-text">解除</div>
      </button>
    </div>
  </div>
</template>
