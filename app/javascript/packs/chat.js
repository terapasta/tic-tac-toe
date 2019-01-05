import ActionCable from 'actioncable'

const cable = ActionCable.createConsumer()
const channel = cable.subscriptions.create({
  channel: 'ChatChannel', bot_token: 'hogehoge'
})