<script>
export default {
  props: {
    isDisabled: { type: Boolean, required: true },
  },

  data: () => ({
    newMessage: '',
  }),

  methods: {
    handleSubmitButtonClick () {
      this.$emit('submit', this.newMessage)
      this.newMessage = ''
    }
  }
}
</script>

<template>
  <div class="container">
    <form>
      <input
        type="text"
        v-model="newMessage"
        :disabled="isDisabled"
        placeholder="質問を入力…"
      />
      <button
        :disabled="isDisabled"
        @click.prevent.stop="handleSubmitButtonClick"
        title="質問を送信"
      >
        <i class="material-icons">send</i>
      </button>
    </form>
  </div>
</template>

<style lang="scss" scoped>
.container {
  height: 100%;
}
form {
  display: flex;
  height: 100%;
}
input[type=text] {
  flex-grow: 2;
  padding: 16px 0;
  border: 0;
  outline: none;
  resize: none;
}
button {
  padding: 0 16px;
  border: 0;
  background-color: transparent;
  color: rgba(94,185,255,1);
  line-height: 100%;
  outline: none;

  &:hover {
    cursor: pointer;
    background-color: #efefef;
  }
}
</style>
