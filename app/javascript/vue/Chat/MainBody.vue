<script>
import Message from './Message'

export default {
  components: {
    Message,
  },

  props: {
    messages: { type: Array, required: true },
  },

  data: () => ({
    isDoneFirstRendering: false,
  }),

  watch: {
    messages: {
      handler (newMessages, oldMessages) {
        this.doneFirstRendering()
        if (newMessages.length > oldMessages.length) {
          this.scrollToBottom()
        }
      }
    }
  },

  methods: {
    doneFirstRendering () {
      if (this.messages.length > 0) {
        setTimeout(() => {
          this.isDoneFirstRendering = true
        }, 100)
      }
    },

    scrollToBottom () {
      this.$nextTick(() => {
        this.$el.scrollTo(0, this.$el.scrollHeight)
      })
    }
  }
}
</script>

<template>
  <div class="body">
    <div class="container">
      <div
        class="row"
        v-for="(message, i) in messages"
        :key="i"
      >
        <message
          :speaker="message.speaker"
          :body="message.body"
          :is-animate="isDoneFirstRendering"
        />
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.body {
  overflow-y: auto;
  flex-grow: 2;
  -webkit-overflow-scrolling: touch;
  overflow-scrolling: touch;
  padding: 32px 0;

  .row {
    margin-bottom: 40px;
    &:last-child {
      margin-bottom: 0;
    }
  }
}
</style>
