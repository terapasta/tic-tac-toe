<template>
  <div class="game">
    <div class="game-board">
      <board :squares="history[stepNumber].squares" 
              @handle-click="handleClick" />
    </div>
    <div class="game-info">
      <div>
        <span v-if="winner">Winner: {{ winner }}</span>
        <span v-else>Next playler: {{xIsNext ? 'X' : 'O'}}</span>
      </div>
      <ol>
        <li v-for="(step, move) in history" :key="move">
          <button @click="jumpTo(move)">
            {{move ? 'Go to move #' + move : 'Go to game start'}}
          </button>
        </li>
      </ol>
    </div>
  </div>
</template>

<script>
  import Board from './Board'
  export default {
    components: { Board },
    data() {
      return {
        history: [{
          squares: Array(9).fill(null)
        }],
        stepNumber: 0,
        xIsNext: true
      }
    },
    computed: {
      winner() {
        const history = this.history
        const current = history[this.stepNumber]
        return this.calculateWinner(current.squares)
      },
    },
    methods: {
      handleClick(squareNum) {
        const history = this.history.slice(0, this.stepNumber + 1)
        const current = history[history.length -1]
        const squares = current.squares.slice()
        if(this.calculateWinner(squares) || squares[squareNum]) {
          return
        }
        squares[squareNum] = this.xIsNext ? 'X' : 'O'
        this.history = history.concat([{
          squares: squares,
        }])
        this.stepNumber = history.length
        this.xIsNext = !this.xIsNext
      },
      jumpTo(step) {
        this.stepNumber = step,
        this.xIsNext = (step % 2) === 0
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
  .game {
    display: flex;
    flex-direction: row;
  }
  .game-info {
    margin-left: 20px;
  }
</style>
