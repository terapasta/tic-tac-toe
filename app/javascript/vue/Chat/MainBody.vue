<script>
import Message from './Message'
import Scroller from '../../helpers/Scroller'

export default {
  components: {
    Message,
  },

  props: {
    bot: { type: Object, required: true },
    messages: { type: Array, required: true },
    headerHeight: { type: Number, required: true },
  },

  data: () => ({
    isDoneFirstRendering: false,
  }),

  mounted () {
    this.$nextTick(() => {
      this.scroller = new Scroller(this.$el, 500)
    })
  },

  watch: {
    messages: {
      handler (newMessages, oldMessages) {
        this.scrollToBottom()
        this.doneFirstRendering()
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
        const lastMessage = this.messages[this.messages.length -  1]
        if (lastMessage == null) { return }
        const destComponent = this.$refs[`message-${lastMessage.id}`][0]
        if (destComponent == null) { return }
        const destElement = destComponent.$el
        this.scroller.scrollTo(destElement.offsetTop - this.headerHeight - 12)
      })
    }
  }
}
</script>

<template>
  <div
    class="body"
  >
    <div class="container">
      <div
        class="row"
        v-for="(message, i) in messages"
        :key="i"
      >
        <message
          :bot="message.speaker === 'bot' ? bot : null"
          :ref="`message-${message.id}`"
          :speaker="message.speaker"
          :body="message.body"
          :message="message"
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
  padding: 32px 0 160px;

  .row {
    margin-bottom: 40px;
    &:last-child {
      margin-bottom: 0;
    }
  }
}
</style>
