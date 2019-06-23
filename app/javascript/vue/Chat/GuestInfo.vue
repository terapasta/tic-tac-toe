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
          <form v-on:submit="handleSubmit">
            <div class="modal-header">
              <div class="modal-title">ゲスト情報</div>
              <button v-if="canClose" class="close" @click="handleCloseClick">
                <i class="material-icons">close</i>
              </button>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label for="name">お名前<sup class="text-danger">*</sup></label>
                <input
                  name="name"
                  type="text"
                  class="form-control"
                  v-model="name"
                  :disabled="disabled"
                />
                <p v-if="nameError" class="text-danger">
                  {{nameError}}
                </p>
              </div>
              <div class="form-group">
                <label for="email">メールアドレス</label>
                <input
                  name="email"
                  type="email"
                  class="form-control"
                  v-model="email"
                  placeholder="例：example@example.com"
                  :disabled="disabled"
                />
              </div>
            </div>
            <div class="modal-footer">
              <input
                type="submit"
                class="btn btn-success"
                value="保存する"
                :disabled="disabled"
                @click="handleSubmit"
              />
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import isEmpty from 'is-empty'

export default {
  props: {
    guestUser: { type: Object },
    disabled: { type: Boolean, required: true },
    skippable: { type: Boolean, required: true },
  },

  data() {
    return {
      isShowModal: this.guestUser == null,
      name: (this.guestUser || {}).name,
      email: (this.guestUser || {}).email,
      nameError: null,
    }
  }, 

  computed: {
    canClose () {
      return (
        (this.guestUser == null && this.skippable) ||
        this.guestUser != null
      )
    }
  },

  methods: {
    handleButtonClick () {
      this.isShowModal = true
    },

    handleCloseClick () {
      if (this.canClose) {
        this.close()
      }
    },

    handleModalClick () {
      if (this.canClose) {
        this.close()
      }
    },

    handleSubmit () {
      const { name, email } = this
      this.nameError = null
      if (isEmpty(name)) {
        this.nameError = 'お名前を入力してください'
        return
      }
      this.$emit('submit', { name, email })
    },

    close () {
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

