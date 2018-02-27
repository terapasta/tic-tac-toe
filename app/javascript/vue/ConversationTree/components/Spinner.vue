<script>
export default {
}
</script>

<template>
  <div class="spinner-container">
    <div class="cover" />
    <i class="material-icons infiniteSpinning spinner">autorenew</i>
  </div>
</template>

<style scoped lang="scss">
%base-cover {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}
.spinner-container {
  @extend %base-cover;
}
.cover {
  @extend %base-cover;
  background-color: rgba(255,255,255,.75);
}
.spinner {
  position: absolute;
  top: calc(50% - 12px);
  left: calc(50% - 12px);
}
</style>