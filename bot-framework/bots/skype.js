const path = require('path')
const get = require('lodash/get')
const isEmpty = require('is-empty')
const {
  UniversalBot,
  Prompts,
  ListStyle,
  Message,
  AttachmentLayout,
  HeroCard,
  CardImage,
  CardAction
} = require('botbuilder')

const {
  NODE_ENV
} = require('../env')

const {
  createChat,
  createMessage,
  createChoice
} = require('../api')

const service_type = 'skype'
const s3 = NODE_ENV === 'development' ?
  'https://my-ope-assets-dev.s3.amazonaws.com' : ''

class Bot {
  constructor(connector) {
    this.connector = connector
    this.bot = new UniversalBot(this.connector, {
      localizerSettings: {
        defaultLocale: 'ja'
      }
    })
    this.bot.dialog('/', this.handleDefaultDialog.bind(this))
    this.bot.dialog('decisionBranches', this.handleDecisionBranchesDialogSteps())
  }

  handleAnswerMessage({ session, res }) {
    const body = get(res, 'data.message.body')
    const decisionBranches = get(res, 'data.message.questionAnswer.decisionBranches')
    const childDecisionBranches = get(res, 'data.message.childDecisionBranches')
    const similarQuestionAnswers = get(res, 'data.message.similarQuestionAnswers')
    const answerFiles = get(res, 'data.message.answerFiles', [])

    if (!isEmpty(decisionBranches) || !isEmpty(childDecisionBranches)) {
      this.sendMessageWithAttachments(session, body, answerFiles)
      // Disaptch decisionBranches Dialog
      return session.beginDialog('decisionBranches', {
        decisionBranches: decisionBranches || childDecisionBranches,
        isSuggestion: false
      })
    } else if (!isEmpty(similarQuestionAnswers)) {
      this.sendMessageWithAttachments(session, body, answerFiles)
      // Disaptch decisionBranches Dialog as suggestion
      return session.beginDialog('decisionBranches', {
        decisionBranches: similarQuestionAnswers,
        isSuggestion: true
      })
    } else {
      this.sendMessageWithAttachments(session, body, answerFiles)
    }
  }

  handleDefaultDialog(session) {
    console.log('default dialog')
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
        guestKey: res.data.chat.guestKey,
        message: session.message.text
      }).then((res) => {
        this.handleAnswerMessage({ session, res })
      })
    )).catch((err) => {
      console.error(err)
      session.send('エラーが発生しました: ' + err.message)
    })
  }

  handleDecisionBranchesDialogSteps() {
    return [
      // Show choices
      (session, { message, decisionBranches, isSuggestion }) => {
        session.privateConversationData.decisionBranches = decisionBranches
        session.privateConversationData.isSuggestion = isSuggestion

        const attrName = isSuggestion ? 'question' : 'body'
        const choices = decisionBranches.map(it => it[attrName])
        let _message = isSuggestion ? 'こちらの質問ではないですか？<br/>' : ''
        _message = !isEmpty(message) ? `${message}<br/>` : _message

        Prompts.choice(session, _message + "※半角数字で解答して下さい", choices, {
          listStyle: ListStyle.list,
          maxRetries: isSuggestion ? 0 : 1
        })
      },
      // Handle selected choice
      (session, results) => {
        const { botToken } = session.message
        const { uid, name } = session.message.user
        const { decisionBranches, isSuggestion } = session.privateConversationData
        const selected = decisionBranches[get(results, 'response.index')]

        if (selected == null) {
          session.endDialog()
          return this.handleDefaultDialog(session)
        }

        session.privateConversationData = {}
        session.sendTyping()

        createChat({
          botToken,
          uid,
          name,
          service_type
        }).then((res) => {
          const { guestKey } = res.data.chat
          if (isSuggestion) {
            createMessage({
              botToken,
              guestKey,
              message: results.response.entity
            }).then((res) => {
              session.endDialog()
              this.handleAnswerMessage({ session, res })
            })
          } else {
            createChoice({
              botToken,
              guestKey,
              choiceId: selected.id
            }).then((res) => {
              session.endDialog()
              this.handleAnswerMessage({ session, res })
            })
          }
        }).catch((err) => {
          console.error(err)
          session.send('エラーが発生しました: ' + err.message)
        })
      }
    ]
  }

  sendMessageWithAttachments(session, message, answerFiles) {
    if (isEmpty(answerFiles)) { return session.send(message) }

    const imageFiles = answerFiles
      .filter(it => /image/.test(it.fileType))
      .map(it => (new HeroCard(session)
        .title(path.basename(it.file.url))
        .images([CardImage.create(session, s3 + it.file.url)])
        .buttons([CardAction.openUrl(session, s3 + it.file.url, '画像を開く')])))

    const otherFiles = answerFiles
      .filter(it => !/image/.test(it.fileType))
      .map(it => (new HeroCard(session)
        .title(decodeURIComponent(path.basename(it.file.url)))
        .buttons([CardAction.openUrl(session, s3 + it.file.url, 'ダンロード')])))

    const msg = new Message(session)
      .attachmentLayout(AttachmentLayout.carousel)
      .attachments(imageFiles.concat(otherFiles))

    session.send(message)
    session.send(msg)
  }
}

module.exports = Bot