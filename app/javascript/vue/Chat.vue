<script>
import { mapActions, mapState } from 'vuex'
import Cookies from 'js-cookie'
import socketio from 'socket.io-client'
import toastr from 'toastr'
import 'toastr/build/toastr.min.css'

import './Chat/css/bot-message-body.css'
import './Chat/css/container.scss'
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
    await this.fetchJwt()
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
      'guestId',
      'guestUser',
      'messages',
      'messagesNextPageExists',
      'isProcessing',
      'isConnected',
      'isStaff',
      'isOwner',
      'notification',
      'botServerHost',
      'isGuestUserRegistrationEnabled',
      'isGuestUserFormSkippable',
    ]),
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
      'fetchJwt',
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

    handleMainBodySelectQuestion (message, questionAnswerId) {
      console.log(questionAnswerId)
      this.createMessage({ message, questionAnswerId })
    },

    handleGood (message) {
      this.good({ message })
    },

    handleBad (message) {
      this.bad({ message })
    },

    async handleGuestInfoSubmit ({ name, email }) {
      try {
        await this.saveGuestUser({ name, email })
        toastr.success('ゲスト情報を保存しました')
        this.$refs.guestInfo.close()
      } catch (err) {
        console.error(err)
        toastr.error('ゲスト情報を保存できませんでした')
      }
    },

    handleMessagesLoadMore () {
      this.fetchMessages({ olderThanId: this.messages[0].id })
    },
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
      <span class="text-secondary font-weight-light">{{bot.name}}</span>
      <guest-info
        ref="guestInfo"
        v-if="isGuestUserRegistrationEnabled"
        :skippable="isGuestUserFormSkippable"
        :guest-id="guestId"
        :guest-user="guestUser"
        :disabled="isProcessing"
        @submit="handleGuestInfoSubmit"
      />
      <span v-else>&nbsp;</span>
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
      :is-owner="isOwner"
      :is-show-load-more-button="messagesNextPageExists"
      :is-processing="isProcessing"
      :suggestions-limit="bot.suggestLimit"
      @select-decision-branch="handleMainBodySelectDecisionBranch"
      @select-question="handleMainBodySelectQuestion"
      @good="handleGood"
      @bad="handleBad"
      @load-more="handleMessagesLoadMore"
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
