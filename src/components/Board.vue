<template>
  <div>
    <div v-for="i in 3" :key="i" class="board-row">
      <span v-for="j in 3" :key="j" @click="handleClick(calcSquareNum(i, j))">
        <square  :value="squares[calcSquareNum(i, j)]"/>
      </span>
    </div>
  </div>
</template>

<script>
import Square from './Square'
export default {
  components: { Square },
  props: {
    squares: Array,
  },
  methods: {
    calcSquareNum(row, col) {
      return row - 1 + (col - 1) * 3
    },
    handleClick(squareNum) {
      this.$emit('handle-click', squareNum)
    }
  },
}
</script>

<style>
.board-row:after {
  clear: both;
  content: "";
  display: table;
}
.status {
  margin-bottom: 10px;
}
</style>
