const get = require('lodash/get')
const isEmpty = require('is-empty')
const {
  UniversalBot,
  Prompts,
  ListStyle
} = require('botbuilder')

const {
  createChat,
  createMessage,
  createChoice
} = require('./api')

const service_type = 'skype'

class Bot {
  constructor(connector) {
    this.connector = connector
    this.bot = new UniversalBot(this.connector)
    this.bot.dialog('/', this.handleDefaultDialog.bind(this))
    this.bot.dialog('decisionBranches', this.handleDecisionBranchesDialogSteps())
  }

  handleAnswerMessage({ session, res }) {
    const body = get(res, 'data.message.body')
    const decisionBranches = get(res, 'data.message.questionAnswer.decisionBranches')
    const similarQuestionAnswers = get(res, 'data.message.similarQuestionAnswers')

    if (!isEmpty(decisionBranches)) {
      // Disaptch decisionBranches Dialog
      return session.beginDialog('decisionBranches', {
        message: body,
        decisionBranches
      })
    } else if (!isEmpty(similarQuestionAnswers)) {
      session.send(body)
      // Disaptch decisionBranches Dialog as suggestion
      return session.beginDialog('decisionBranches', {
        decisionBranches: similarQuestionAnswers
      })
    } else {
      return session.send(body)
    }
  }

  handleDefaultDialog(session) {
    const { botToken } = session.message
    const { uid, name } = session.message.user

    session.sendTyping()

    // POST /api/bots/:token/chats.json
    createChat({
      botToken,
      uid,
      name,
      service_type
    }).then((res) => (
      // POST /api/bots/:token/chats/:id/messages.json
      createMessage({
        botToken,
        chatId: res.data.chat.id,
        message: session.message.text
      }).then((res) => {
        this.handleAnswerMessage({ session, res })
      })
    )).catch((err) => {
      console.error(err)
      session.send('エラーが発生しました: ' + err.message)
    })
  }

  handleDecisionBranchesDialog() {
    return [
      // Show choices
      (session, { message, decisionBranches}) => {
        session.privateConversationData.decisionBranches = decisionBranches
        const choices = decisionBranches.map(it => it.body)

        Prompts.choice(session, message, choices, {
          listStyle: ListStyle.list
        })
      },
      // Handle selected choice
      (session, results) => {
        const { botToken } = session.message
        const { uid, name } = session.message.user
        const { decisionBranches } = session.privateConversationData
        const selected = decisionBranches[results.response.index]

        session.sendTyping()

        createChat({
          botToken,
          uid,
          name,
          service_type
        }).then((res) => {
          createChoice({
            botToken,
            guestKey: res.data.chat.guestKey,
            choiceId: selected.id
          }).then((res) => {
            session.endDialog()
            this.handleAnswerMessage({ session, res })
          })
        }).catch((err) => {
          console.error(err)
          session.send('エラーが発生しました: ' + err.message)
        })
      }
    ]
  }
}

module.exports = Bot