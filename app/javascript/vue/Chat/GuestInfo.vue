<template>
  <div :class="{ 'modal-open': isShowModal }">
    <button class="btn btn-link" @click="handleButtonClick">
      <i class="material-icons">person</i>
    </button>
    <div v-if="isShowModal" class="modal-backdrop fade show" />
    <div
      v-if="isShowModal"
      class="modal"
      :style="{ display: 'block' }"
      @click="handleModalClick"
    >
      <div class="modal-dialog" @click.prevent.stop>
        <div class="modal-content">
          <form>
            <div class="modal-header">
              <div class="modal-title">ゲスト情報</div>
              <button class="close" @click="handleCloseClick">
                <i class="material-icons">close</i>
              </button>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label for="name">お名前</label>
                <input
                  name="name"
                  type="text"
                  class="form-control"
                  v-modal="name"
                />
              </div>
              <div class="form-group">
                <label for="email">メールアドレス</label>
                <input
                  name="email"
                  type="email"
                  class="form-control"
                  v-modal="email"
                  placeholder="例：example@example.com"
                />
              </div>
            </div>
            <div class="modal-footer">
              <button class="btn btn-success">保存する</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data: () => ({
    isShowModal: false,
    name: '',
    email: '',
  }),

  methods: {
    handleButtonClick () {
      this.isShowModal = true
    },

    handleCloseClick () {
      this.isShowModal = false
    },

    handleModalClick () {
      this.isShowModal = false
    }
  }
}
</script>

<style lang="scss" scoped>
.btn.btn-link {
  color: #888888;
  display: flex;
  align-items: center;

  &:hover, &:active {
    text-decoration: none;
  }
}

.modal-content {
  border: 0;
}

.modal-header {
  border-bottom: 0;
}

.modal-footer {
  border-top: 0;
}
</style>

