<template>
  <div>
    <div class="status">
      <span v-if="winner">Winner: {{ winner }}</span>
      <span v-else>Next playler: {{xIsNext ? 'X' : 'O'}}</span>
    </div>
    <div v-for="i in 3" :key="i" class="board-row">
      <div v-for="j in 3" :key="j" @click="handleClick(calcSquareNum(i, j))">
        <square  :value="squares[calcSquareNum(i, j)]"/>
      </div>
    </div>
  </div>
</template>

<script>
import Square from './Square'
export default {
  components: { Square },
  data() {
    return {
      squares: Array(9).fill(null),
      xIsNext: true,
    }
  },
  computed: {
    winner() {
      return this.calculateWinner(this.squares)
    }
  },
  methods: {
    calcSquareNum(row, col) {
      return row - 1 + (col - 1) * 3
    },
    handleClick(squareNum) {
      const squares = this.squares.slice()
      if(this.calculateWinner(squares) || squares[squareNum]) {
        return
      }
      squares[squareNum] = this.xIsNext ? 'X' : 'O'
      this.squares = squares
      this.xIsNext = !this.xIsNext
    },
    calculateWinner(squares) {
      const lines = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6],
      ]
      for (let i = 0; i < lines.length; i++) {
        const [a, b, c] = lines[i];
        if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
          return squares[a];
        }
      }
      return null;
    }
  }
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
