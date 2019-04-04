<script>
import { mapActions, mapState } from 'vuex'
import ActionCable from 'actioncable'
import Cookies from 'js-cookie'

import './Chat/css/bot-message-body.css'
import { createWebsocketHandlers } from './Chat/store/websocketHandlers'

import ChatForm from './Chat/ChatForm'
import MainBody from './Chat/MainBody'
import Notification from './Chat/Notification'

export default {
  components: {
    ChatForm,
    MainBody,
    Notification,
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
      'bot',
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

    handleChatFormSubmit (message) {
      this.createMessage({ message })
    },
  }
}
</script>

<template>
  <div class="Chat">
    <div class="header">
      <notification
        message="サンプルメッセージサンプルメッセージ"
      />
    </div>

    <main-body
      :bot="bot"
      :messages="messages"
      :header-height="40"
    />

    <div class="footer">
      <chat-form
        :is-disabled="isProcessing"
        @submit="handleChatFormSubmit"
      />
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
  position: relative;
  height: 40px;
  background-color: #fff;
  flex-shrink: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer {
  height: 64px;
  background-color: #fff;
  flex-shrink: 0;
}
</style>
