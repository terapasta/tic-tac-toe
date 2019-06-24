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
    isStaff: { type: Boolean, required: true, default: false },
    isOwner: { type: Boolean, required: true, default: false },
    isShowLoadMoreButton: { type: Boolean, default: false },
    isProcessing: { type: Boolean, default: false },
    suggestionsLimit: { type: Number, default: 10 },
  },

  data: () => ({
    isDoneFirstRendering: false,
    stayPositionTo: null,
    stayPositionY: 0,
  }),

  mounted () {
    this.$nextTick(() => {
      this.scroller = new Scroller(this.$el, 500)
    })
  },

  watch: {
    messages: {
      handler (newMessages, oldMessages) {
        if (this.stayPositionId != null && this.stayPositionY != null) {
          return this.scrollToStayPosition()
        }
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
        const lastMessage = this.messages[this.messages.length -  1]
        if (lastMessage == null) { return }
        const destComponent = this.$refs[`message-${lastMessage.id}`][0]
        if (destComponent == null) { return }
        const destElement = destComponent.$el
        this.scroller.scrollTo(destElement.offsetTop - this.headerHeight - 12)
      })
    },

    scrollToStayPosition () {
      this.$nextTick(() => {
        const comp = this.$refs[`message-${this.stayPositionId}`][0]
        const top = comp.$el.offsetTop - this.stayPositionY || 0
        this.$el.scrollTo(0, top)
        this.stayPositionId = null
        this.stayPositionY = null
        this.doneFirstRendering()
      })
    },

    handleLoadMoreButtonClick () {
      if (this.isProcessing) { return }
      this.isDoneFirstRendering = false
      const { id } = this.messages[0]
      this.stayPositionId = id
      this.stayPositionY = this.$refs[`message-${id}`][0].$el.offsetTop
      this.$emit('load-more')
    },

    handleSelectQuestion (question, id) {
      this.$emit('select-question', question, id)
    }
  }
}
</script>

<template>
  <div
    class="body"
  >
    <div
      v-if="isShowLoadMoreButton"
      class="mb-3 text-center"
    >
      <button
        class="btn btn-primary"
        @click.prevent.stop="handleLoadMoreButtonClick"
        :disabled="isProcessing"
      >
        <template v-if="isProcessing">
          読み込み中...
        </template>
        <template v-else>
          さらに読み込む
        </template>
      </button>
    </div>
    <div
      v-for="(message, i) in messages"
      :key="i"
      class="message"
    >
      <message
        :bot="message.speaker === 'bot' ? bot : null"
        :ref="`message-${message.id}`"
        :speaker="message.speaker"
        :body="message.body"
        :message="message"
        :is-animate="isDoneFirstRendering"
        :is-staff="isStaff"
        :is-owner="isOwner"
        :suggestions-limit="suggestionsLimit"
        @select-decision-branch="$emit('select-decision-branch', $event)"
        @select-question="handleSelectQuestion"
        @select-no-applicable="$emit('select-no-applicable')"
        @good="$emit('good', $event)"
        @bad="$emit('bad', $event)"
        @initial-selection-move-higher="$emit('initial-selection-move-higher', $event)"
        @initial-selection-move-lower="$emit('initial-selection-move-lower', $event)"
      />
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

  .message {
    margin-bottom: 40px;
    &:last-child {
      margin-bottom: 0;
    }
  }
}
</style>
