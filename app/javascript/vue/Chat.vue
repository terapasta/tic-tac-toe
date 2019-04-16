<script>
import { mapActions, mapState } from 'vuex'
import Cookies from 'js-cookie'
import socketio from 'socket.io-client'

import './Chat/css/bot-message-body.css'
import { createWebsocketHandlers } from './Chat/store/websocketHandlers'
import ChatForm from './Chat/ChatForm'
import ConnectionStatus from './Chat/ConnectionStatus'
import GuestInfo from './Chat/GuestInfo'
import MainBody from './Chat/MainBody'
import Notification from './Chat/Notification'

export default {
  components: {
    ChatForm,
    ConnectionStatus,
    GuestInfo,
    MainBody,
    Notification,
  },

  data: () => ({
    newMessage: '',
  }),

  async created () {
    await this.initAPI()
    this.fetchMessages()

    const socket = socketio(this.botServerHost)
    const websocketHandlers = createWebsocketHandlers(this.$store, socket)
    socket.on('connect', websocketHandlers.connect)
    socket.on('disconnect', websocketHandlers.disconnect)
    socket.on('event', websocketHandlers.event)
  },

  computed: {
    ...mapState([
      'bot',
      'botToken',
      'guestKey',
      'messages',
      'isProcessing',
      'isConnected',
      'isStaff',
      'notification',
      'botServerHost',
    ])
  },

  methods: {
    ...mapActions([
      'initAPI',
      'fetchMessages',
      'createMessage',
      'clearNotification',
      'selectDecisionBranch',
      'good',
      'bad',
      'saveGuestUser',
    ]),

    handleChatFormSubmit (message) {
      this.createMessage({ message })
    },

    handleNotificationClose () {
      this.clearNotification()
    },

    handleMainBodySelectDecisionBranch (decisionBranch) {
      this.selectDecisionBranch({ decisionBranch })
    },

    handleMainBodySelectQuestion (message) {
      this.createMessage({ message })
    },

    handleGood (message) {
      this.good({ message })
    },

    handleBad (message) {
      this.bad({ message })
    },

    handleGuestInfoSubmit ({ name, email }) {
      console.log('test', name, email)
      this.saveGuestUser({ name, email })
    }
  }
}
</script>

<template>
  <div class="Chat">
    <div class="header">
      <connection-status
        :is-success="isConnected === true"
        :is-danger="isConnected === false"
      />
      <guest-info
        @submit="handleGuestInfoSubmit"
      />
      <notification
        v-if="notification"
        :message="notification"
        @close="handleNotificationClose"
      />
    </div>

    <main-body
      :bot="bot"
      :messages="messages"
      :header-height="40"
      :is-staff="isStaff"
      @select-decision-branch="handleMainBodySelectDecisionBranch"
      @select-question="handleMainBodySelectQuestion"
      @good="handleGood"
      @bad="handleBad"
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
