const path = require('path')
const dotenv = require('dotenv')
const restify = require('restify')

const {
  ChatConnector,
  UniversalBot,
  Prompts,
  ListStyle
} = require('botbuilder')

const {
  createChat,
  createMessage
} = require('./api')

dotenv.config({ path: path.dirname(__dirname) + '/.env' })

const {
  port,
  MICROSOFT_APP_ID,
  MICROSOFT_APP_PASSWORD,
} = process.env

const connector = new ChatConnector({
  appId: MICROSOFT_APP_ID,
  appPassword: MICROSOFT_APP_PASSWORD
})
const bot = new UniversalBot(connector)

// event listener for all messages
bot.dialog('/', function (session) {
  const botToken = '0e70b78588dbd09c7682e0c84e94abaf4880c8e41e50be2118253bb6146da112'
  const { uid, name } = session.message.user
  const service_type = 'skype'

  // POST /api/bots/:token/chats.json
  createChat({
    token: botToken,
    uid,
    name,
    service_type
  }).then((res) => (
    // POST /api/bots/:token/chats/:id/messages.json
    createMessage({
      token: botToken,
      chatId: res.data.chat.id,
      message: session.message.text
    }).then((res) => {
      // TODO return response
      session.send(res.data.message.body)
      // TODO disaptch decisionBranchDialog
      if (res.data.message.decisionBranches.length > 0) {
        session.beginDialog('decisionBranches', {
          decisionBranches: 'test desu'
        })
      }
    })
  )).catch((err) => {
    console.error(err)
    session.send('エラーが発生しました: ' + err.message)
  })

  // stub.reply(req, (err, res) => {
  //   if (err) {
  //     console.error(err)
  //   }
  //   session.send(JSON.stringify(res.results[0]))
  //   session.beginDialog('decisionBranches')

  //   console.log('userData', JSON.stringify(session.userData))
  //   console.log('message.user', JSON.stringify(session.message.user))
  //   session.userData.hoge = 'hogehogehoge'
  //   session.save()
  // })
})

bot.dialog('decisionBranches', [
  (session, args) => {
    console.log(JSON.stringify(args))
    Prompts.choice(session, '選択肢のテスト??', [
      'aaa',
      'bbb',
      'ccc'
    ],
    {
      listStyle: ListStyle.list
    })
  },
  (session, results) => {
    session.endDialog(`${JSON.stringify(results.response)}を選択しましたね`)
  }
])

// Setup Restify Server
var server = restify.createServer()
server.post('/', connector.listen())
server.listen(port || 3978, function () {
  console.log('%s listening to %s', server.name, server.url);
})
