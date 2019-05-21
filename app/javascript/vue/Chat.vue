<script>
import { mapActions, mapState } from 'vuex'
// import ActionCable from 'actioncable'
import Cookies from 'js-cookie'

import { createWebsocketHandlers } from './Chat/store/websocketHandlers'

export default {
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
  <div>
    <ul>
      <li v-for="(message, i) in messages" :key="i">
        [{{message.speaker}}] {{message.body}}
      </li>
    </ul>
    <div>
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

<style>

</style>
