const {
  ChatConnector,
} = require('botbuilder')
const line = require('@line/bot-sdk')

const LineBot = require('./bots/line')
const SkypeBot = require('./bots/skype')

const AllServer = require('./servers/all')
const ChatworkServer = require('./servers/chatwork')
const LineServer = require('./servers/line')
const SkypeServer = require('./servers/skype')

const {
  MICROSOFT_APP_ID,
  MICROSOFT_APP_PASSWORD,
  LINE_CHANNEL_SECRET,
  LINE_CHANNEL_ACCESS_TOKEN
} = require('./env')

const skypeConnector = new ChatConnector({
  appId: MICROSOFT_APP_ID,
  appPassword: MICROSOFT_APP_PASSWORD
})

const lineConfig = {
  channelSecret: LINE_CHANNEL_SECRET,
  channelAccessToken: LINE_CHANNEL_ACCESS_TOKEN
}
const lineClient = new line.Client(lineConfig)

const lineBot = new LineBot(lineClient)
new SkypeBot(skypeConnector)

const chatworkServer = new ChatworkServer()
const lineServer = new LineServer(lineClient, lineBot)
const skypeServer = new SkypeServer(skypeConnector.listen())
new AllServer({ skypeServer, lineServer, chatworkServer }).run()