<script>
export default {
  props: {
    isSuccess: { type: Boolean, default: false },
    isDanger: { type: Boolean, default: false },
  }
}
</script>

<template>
  <div class="wrapper">
    <div class="dot" :class="{ success: isSuccess, danger: isDanger }" />
  </div>
</template>

<style lang="scss" scoped>
.dot {
  display: inline-block;
  margin: 0 16px 0 20px;
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background-color: #999;
  position: relative;
  top: -2px;

  &.success {
    background-color: #28a745;
    box-shadow: 0 0 8px 2px #c3e6cb;
  }
  &.danger {
    background-color: #dc3545;
    box-shadow: 0 0 8px 2px #f5c6cb;
  }
}

.desc {
  display: inline-block;
  font-size: 0.8rem;
  color: #999;
}
</style>
