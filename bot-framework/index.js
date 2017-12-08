const {
  ChatConnector,
} = require('botbuilder')

const SkypeBot = require('./bots/skype')

const AllServer = require('./servers/all')
const ChatworkServer = require('./servers/chatwork')
const LineServer = require('./servers/line')
const SkypeServer = require('./servers/skype')

const {
  MICROSOFT_APP_ID,
  MICROSOFT_APP_PASSWORD
} = require('./env')

const skypeConnector = new ChatConnector({
  appId: MICROSOFT_APP_ID,
  appPassword: MICROSOFT_APP_PASSWORD
})

new SkypeBot(skypeConnector)

const chatworkServer = new ChatworkServer()
const lineServer = new LineServer()
const skypeServer = new SkypeServer(skypeConnector.listen())
new AllServer({ skypeServer, lineServer, chatworkServer }).run()