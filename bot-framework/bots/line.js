const api = require('../api')
const get = require('lodash.get')
const isEmpty = require('is-empty')

const {
  NODE_ENV
} = require('../env')

const s3 = NODE_ENV === 'development' ?
  'https://my-ope-assets-dev.s3.amazonaws.com' : ''

const service_type = 'line'
const PostbackTypes = {
  QuestionAnswer: 'question_answer',
  DecisionBranch: 'decision_branch'
}

const truncate = (str, limit) => {
  if (isEmpty(str)) { return str }
  if (str.length > limit) {
    return str.slice(0, limit - 1) + '…'
  } else {
    return str
  }
}

const toActionData = ({ questionAnswer, decisionBranch }) => {
  if (!isEmpty(questionAnswer)) {
    return {
      type: PostbackTypes.QuestionAnswer,
      id: questionAnswer.id
    }
  } else if (!isEmpty(decisionBranch)) {
    return {
      type: PostbackTypes.DecisionBranch,
      id: decisionBranch.id
    }
  }
}

class LineBot {
  constructor(lineClient) {
    this.lineClient = lineClient
    this.handleEvent = this.handleEvent.bind(this)
  }

  handleEvent (botToken, event) {
    if (event.type === 'postback') {
      return this.handlePostbackEvent(botToken, event)
    }

    if (event.type !== 'message' || event.message.type !== 'text') {
      return api.fetchPublicBot({ botToken }).then(res => {
        return this.replyText(event, res.data.bot.classifyFailedMessage)
      })
    }

    const userId = get(event, 'source.userId')

    return this.lineClient.getProfile(userId).then(profile => {
      return api.createChat({
        botToken,
        uid: userId,
        service_type,
        name: profile.displayName
      }).then(res => {
        return api.createMessage({
          botToken,
          guestKey: res.data.chat.guestKey,
          message: event.message.text
        }).then((res) => {
          return this.handleAnswerMessage({ event, res })
        })
      })
    })
  }

  handleAnswerMessage ({ event, res }) {
    const body = get(res, 'data.message.body')
    const decisionBranches = get(res, 'data.message.questionAnswer.decisionBranches')
    const childDecisionBranches = get(res, 'data.message.childDecisionBranches')
    const similarQuestionAnswers = get(res, 'data.message.similarQuestionAnswers')
    const isShowSimilarQuestionAnswers = get(res, 'data.message.isShowSimilarQuestionAnswers', false)
    const answerFiles = get(res, 'data.message.answerFiles', [])

    let messages = []

    if (!isEmpty(decisionBranches) || !isEmpty(childDecisionBranches)) {
      // Disaptch decisionBranches Dialog
      messages = messages.concat(this.messageWithDecisionBranches(body, decisionBranches || childDecisionBranches))
      messages = messages.concat(this.messageWithAttachments(null, answerFiles))
    } else if (!isEmpty(similarQuestionAnswers) && isShowSimilarQuestionAnswers) {
      // Disaptch decisionBranches Dialog as suggestion
      messages = messages.concat(this.messageWithAttachments(body, answerFiles))
      messages = messages.concat(this.messageWithDecisionBranches(body, similarQuestionAnswers, true))
    } else {
      messages = messages.concat(this.messageWithAttachments(body, answerFiles))
    }

    return this.lineClient.replyMessage(event.replyToken, messages)
  }

  handlePostbackEvent (botToken, event) {
    const data = JSON.parse(event.postback.data)
    const userId = get(event, 'source.userId')

    return this.lineClient.getProfile(userId).then(profile => {
      return api.createChat({
        botToken,
        uid: userId,
        service_type,
        name: profile.displayName
      }).then(res => {
        const { guestKey } = res.data.chat
        let promise
        switch (data.type) {
          case PostbackTypes.QuestionAnswer:
            promise = api.createMessage({
              botToken,
              guestKey,
              questionAnswerId: data.id
            })
            break
          case PostbackTypes.DecisionBranch:
            promise = api.createChoice({
              botToken,
              guestKey,
              choiceId: data.id
            })
            break
          default: break
        }
        return promise.then(res => this.handleAnswerMessage({ event, res }))
      })
    })
  }

  messageWithAttachments(message, answerFiles) {
    if (isEmpty(answerFiles) && !isEmpty(message)) {
      return [{ type: 'text', text: message }]
    }

    const imageFiles = answerFiles
      .filter(it => /image/.test(it.fileType))
      .map(it => ({
        type: 'image',
        originalContentUrl: s3 + it.file.url,
        previewImageUrl: s3 + it.file.url
      }))

    const otherFiles = answerFiles
      .filter(it => !/image/.test(it.fileType))
      .map(it => ({
        type: 'text',
        text: `添付ファイル\n${s3 + it.file.url}`
      }))

    const allFiles = imageFiles.concat(otherFiles)
    let allMessages = allFiles
    if (!isEmpty(message)) {
      const textObj = { type: 'text', text: message }
      allMessages = [textObj].concat(allFiles)
    }
    allMessages = allMessages.slice(0, 5)

    return allMessages
  }

  messageWithDecisionBranches (message, decisionBranches, isSuggestion = false) {
    const attrName = isSuggestion ? 'question' : 'body'
    const actionKey = isSuggestion ? 'questionAnswer' : 'decisionBranch'
    const text = isSuggestion ? 'こちらの質問ではないですか？' : truncate(message, 160)
    const messageObj = {
      type: 'template',
      altText: 'alt text',
      template: {
        type: 'buttons',
        text,
        actions: decisionBranches.slice(0, 4).map(it => ({
          type: 'postback',
          label: truncate(it[attrName], 20),
          data: JSON.stringify(toActionData({ [actionKey]: it }))
        }))
      }
    }
    return [messageObj]
  }

  replyText(event, text) {
    return this.lineClient.replyMessage(event.replyToken, {
      type: 'text',
      text
    })
  }
}

module.exports = LineBot