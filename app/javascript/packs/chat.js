import ActionCable from 'actioncable'
import Cookies from 'js-cookie'

const guestKey = Cookies.get().guest_key
const botToken = window.location.pathname.split('/')[2]

const cable = ActionCable.createConsumer()
const channel = cable.subscriptions.create({
  channel: 'ChatChannel',
  bot_token: botToken,
  guest_key: guestKey
}, {
  connected () {
    console.log('connected')
  },

  disconnected () {
    console.log('disconnected')
  },

  rejected () {
    console.log('rejected')
  },

  received (...args) {
    console.log(...args)
  }
})

channel.consumer.connection.webSocket.onerror = err => {
  console.log('an error occurred')
}
