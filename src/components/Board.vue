<template>
  <div>
    <div class="board-row">
      <square value="1"></square>
      <square value="2"></square>
      <square value="3"></square>
    </div>
    <div class="board-row">
      <square value="4"></square>
      <square value="5"></square>
      <square value="6"></square>
    </div>
    <div class="board-row">
      <square value="7"></square>
      <square value="8"></square>
      <square value="9"></square>
    </div>
  </div>
</template>

<script>
import Square from './Square'
export default {
  components: { Square },

}
</script>

<style>
.board-row:after {
  clear: both;
  content: "";
  display: table;
}
</style>
