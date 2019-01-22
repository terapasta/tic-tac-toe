<script>
import { mapActions, mapState } from 'vuex'
import ActionCable from 'actioncable'
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
  <div class="Chat">
    <div class="header">
    </div>

    <div class="body">
      <div class="container">
        <div
          class="row"
          v-for="(message, i) in messages"
          :key="i"
        >
          <div
            class="col-10"
            :class="{ 'offset-2': message.speaker === 'guest' }"
          >
            <div v-if="message.speaker === 'bot'">
              <div class="avatar"></div>
            </div>
            <div
              class="balloon"
              :class="`balloon--${message.speaker}`"
            >
              [{{message.speaker}}] {{message.body}}
            </div>
          </div>
        </div>
      </div>
    </div>

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

.avatar {
  margin-bottom: 12px;
  margin-left: -4px;
  width: 48px;
  height: 48px;
  background-color: #ddd;
  border-radius: 50%;
}

.balloon {
  padding: 12px 16px;
  border-radius: 16px;
  background-color: #fff;
  box-shadow: 0 16px 24px -8px rgba(0, 0, 0, .05);

  &--bot {
    background: rgba(94,185,255,1);
    background: -moz-linear-gradient(-45deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    background: -webkit-gradient(left top, right bottom, color-stop(0%, rgba(94,185,255,1)), color-stop(100%, rgba(39,96,194,1)));
    background: -webkit-linear-gradient(-45deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    background: -o-linear-gradient(-45deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    background: -ms-linear-gradient(-45deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    background: linear-gradient(135deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#5eb9ff', endColorstr='#2760c2', GradientType=1 );
    color: #fff;
    box-shadow: 0 16px 24px -8px rgba(94,185,255,0.2);
    border-top-left-radius: 0px;
  }

  &--guest {
    border-top-right-radius: 0px;
  }
}
</style>
