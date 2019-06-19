<template>
  <div class="game">
    <div class="game-board">
      <board></board>
    </div>
  </div>
</template>

<script>
import Board from './Board'
export default {
  components: { Board },
}
</script>
