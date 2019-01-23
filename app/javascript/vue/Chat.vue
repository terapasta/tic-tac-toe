<script>
import { mapActions, mapState } from 'vuex'
import ActionCable from 'actioncable'
import Cookies from 'js-cookie'

import { createWebsocketHandlers } from './Chat/store/websocketHandlers'

import MainBody from './Chat/MainBody'

export default {
  components: {
    MainBody,
  },

  data: () => ({
    newMessage: '',
  }),

  created () {
    this.fetchMessages()

    const websocketHandlers = createWebsocketHandlers(this.$store)
    const cable = ActionCable.createConsumer()
    const channel = cable.subscriptions.create({
      channel: 'ChatChannel',
      bot_token: this.botToken,
      guest_key: this.guestKey,
    }, websocketHandlers)
    websocketHandlers.bindError(channel)
  },

  computed: {
    ...mapState([
      'botToken',
      'guestKey',
      'messages',
      'isProcessing',
    ])
  },

  methods: {
    ...mapActions([
      'fetchMessages',
      'createMessage',
    ]),

    handleSubmitButonClick () {
      this.createMessage({ message: this.newMessage })
      this.newMessage = ''
    },

  }
}
</script>

<template>
  <div class="Chat">
    <div class="header">
    </div>

    <main-body
      :messages="messages"
    />

    <div class="footer">
      <form>
        <textarea
          v-model="newMessage"
          :disabled="isProcessing"
        />
        <button
          :disabled="isProcessing"
          @click.prevent.stop="handleSubmitButonClick"
        >
          送信
        </button>
      </form>
    </div>
  </div>
</template>

<style scoped lang="scss">
.Chat {
  height: 100%;
  position: relative;
  background-color: #f7f7fa;
  display: flex;
  flex-direction: column;
}

.header {
  height: 40px;
  background-color: #fff;
  flex-shrink: 0;
}

.footer {
  height: 64px;
  background-color: #fff;
  flex-shrink: 0;
}
</style>
