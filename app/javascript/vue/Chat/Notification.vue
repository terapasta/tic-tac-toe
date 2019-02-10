<script>
export default {
  props: {
    message: { type: String, required: true },
  },

  computed: {
    className () {
      return {
        notification: true,
        info: true,
        success: false,
        danger: false,
      }
    }
  }
}
</script>

<template>
  <transition
    name="fade"
    appear
  >
    <div :class="className">
      <div class="message">{{message}}</div>
      <button class="close" @click="$emit('close')">
        <i class="material-icons">close</i>
      </button>
    </div>
  </transition>
</template>

<style lang="scss" scoped>
.notification {
  position: absolute;
  top: 100%;
  left: 50%;
  z-index: 100;
  transform: translateX(-50%);
  max-width: 80%;
  padding: 8px 16px;
  border-radius: 0 0 8px 8px;
  box-shadow: 0 16px 24px -8px rgba(0, 0, 0, .05);
  word-wrap: break-word;
  display: flex;

  &.info {
    color: #856404;
    background-color: #fff3cd;
    border-color: #ffeeba;
  }

  &.success {
    color: #155724;
    background-color: #d4edda;
    border-color: #c3e6cb;
  }

  &.danger {
        color: #721c24;
    background-color: #f8d7da;
    border-color: #f5c6cb;
  }

  .message {
    margin-right: 8px;
  }

  .close {
    flex-shrink: 1;
  }
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 1s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
