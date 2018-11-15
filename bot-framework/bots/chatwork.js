const get = require('lodash.get')
const pick = require('lodash.pick')
const request = require('request')
const isEmpty = require('is-empty')

const api = require('../api')
const { MYOPE_API_URL } = require('../env')

// const {
//   NODE_ENV
// } = require('../env')

// const s3 = NODE_ENV === 'development' ? 'https://my-ope-assets-dev.s3.amazonaws.com' : ''
const s3 = ''
const BASE_URL = 'https://api.chatwork.com/v2'
const service_type = 'chatwork'

class ChatworkBot {
  constructor (apiToken) {
    this.apiToken = apiToken
  }

  handleEvent (reqBody) {
    const {
      botToken,
      webhook_event: {
        from_account_id: fromAccountId,
        body
      }
    } = reqBody

    this.fetchUsers().then(users => {
      const user = users.filter(it => it.account_id === fromAccountId)[0]
      if (user === undefined) { return }

      let chatId

      api.createChat({
        botToken,
        uid: fromAccountId,
        service_type,
        name: user.name
      }).then(res => {
        const { guestKey } = res.data.chat
        chatId = res.data.chat.id

        return api.createMessage({
          botToken,
          guestKey,
          message: body
        })
      }).then(res => {
        const { body, answerFiles } = res.data.message

        const decisionBranches = get(res, 'data.message.questionAnswer.decisionBranches', [])
        const childDecisionBranches = get(res, 'data.childDecisionBranches', [])
        const mergedDecisionBranches = decisionBranches.concat(childDecisionBranches)
        const similarQuestionAnswers = get(res, 'data.message.similarQuestionAnswers')
        const isShowSimilarQuestionAnswers = get(res, 'data.message.isShowSimilarQuestionAnswers', false)

        this.sendReply(reqBody, user.name, body, answerFiles, mergedDecisionBranches, chatId, similarQuestionAnswers, isShowSimilarQuestionAnswers)
      }).catch(console.error)
    }).catch(console.error)
  }

  handleDecisionBranch (req, response) {
    const { botToken, chatId } = req.params
    const {
      room_id: roomId,
      from_account_id: fromAccountId,
      decision_branch_id: decisionBranchId,
      decision_branch_body: decisionBranchBody
    } = req.body

    this.fetchUsers().then(users => {
      const user = users.filter(it => it.account_id === global.parseInt(fromAccountId))[0]
      if (user === undefined) { return }

      api.fetchChat({ botToken, chatId }).then(res => {
        const { guestKey } = res.data.chat

        return api.createChoice({
          botToken,
          guestKey,
          choiceId: decisionBranchId
        })
      }).then(res => {
        const answerBody = get(res, 'data.message.body')
        const body = `${user.name}さんが選択\n「${decisionBranchBody}」\n\n${answerBody}`
        const decisionBranches = get(res, 'data.message.questionAnswer.decisionBranches', [])
        const childDecisionBranches = get(res, 'data.message.childDecisionBranches', [])
        const similarQuestionAnswers = get(res, 'data.message.similarQuestionAnswers', [])
        const isShowSimilarQuestionAnswers = get(res, 'data.message.isShowSimilarQuestionAnswers', false)
        const answerFiles = get(res, 'data.message.answerFiles', [])
        const reqBody = {
          webhook_event: {
            room_id: roomId,
            from_account_id: fromAccountId
          }
        }

        const mergedDecisionBranches = decisionBranches.concat(childDecisionBranches)

        this.sendReply(reqBody, user.name, body, answerFiles, mergedDecisionBranches, chatId, similarQuestionAnswers, isShowSimilarQuestionAnswers)
          .then(() => { response.send('OK') })
      })
    }).catch(console.error)
  }

  handleSimilarQuestionAnswer (req, response) {
    const { botToken, chatId } = req.params
    const {
      room_id: roomId,
      from_account_id: fromAccountId,
      question
    } = req.body

    this.fetchUsers().then(users => {
      const user = users.filter(it => it.account_id === global.parseInt(fromAccountId))[0]
      if (user === undefined) { return }

      return api.fetchChat({ botToken, chatId }).then(res => {
        const { guestKey } = res.data.chat

        return api.createMessage({
          botToken,
          guestKey,
          message: question
        })
      }).then(res => {
        const answerBody = get(res, 'data.message.body')
        const body = `${user.name}さんが選択\n「${question}」\n\n${answerBody}`
        const decisionBranches = get(res, 'data.message.questionAnswer.decisionBranches', [])
        const childDecisionBranches = get(res, 'data.message.childDecisionBranches', [])
        const similarQuestionAnswers = get(res, 'data.message.similarQuestionAnswers', [])
        const isShowSimilarQuestionAnswers = get(res, 'data.message.isShowSimilarQuestionAnswers', false)
        const answerFiles = get(res, 'data.message.answerFiles', [])
        const reqBody = {
          webhook_event: {
            room_id: roomId,
            from_account_id: fromAccountId
          }
        }

        const mergedDecisionBranches = decisionBranches.concat(childDecisionBranches)

        this.sendReply(reqBody, user.name, body, answerFiles, mergedDecisionBranches, chatId, similarQuestionAnswers, isShowSimilarQuestionAnswers)
          .then(() => { response.send('OK') })
      })
    }).catch(console.error)
  }

  fetchUsers () {
    return new Promise((resolve, reject) => {
      request({
        method: 'GET',
        url: `${BASE_URL}/contacts`,
        headers: this.reqHeaders()
      }, (err, res, body) => {
        if (err) {
          return reject(err)
        }
        resolve(JSON.parse(body))
      })
    })
  }

  sendReply (reqBody, userName, text, answerFiles, decisionBranches, chatId, similarQuestionAnswers, isShowSimilarQuestionAnswers) {
    const roomId = reqBody.webhook_event.room_id
    const fromAccountId = reqBody.webhook_event.from_account_id
    let decisionBranchLinkList, similarQuestionAnswersLinkList

    const process = () => {
      const url = `${BASE_URL}/rooms/${roomId}/messages`
      const answerFileUrls = (answerFiles || []).map(it => s3 + it.file.url).join('\n')
      const answerFileText = answerFileUrls.length > 0 ? `\n\n<添付ファイル>\n${answerFileUrls}` : ''
      let body = `[To:${fromAccountId}] ${userName}さん\n${text}${answerFileText}`
      if (!isEmpty(decisionBranchLinkList)) {
        body += `\n\n<回答を選択してください>\n${decisionBranchLinkList}`
      }
      if (!isEmpty(similarQuestionAnswersLinkList)) {
        body += `\n\n<こちらの質問ではないですか？>\n${similarQuestionAnswersLinkList}`
      }
      const formData = { body }

      request({
        method: 'POST',
        url,
        headers: this.reqHeaders(),
        formData
      }, (err, res, body) => {
        if (err) {
          return console.error(err)
        }
      })
    }

    if (isEmpty(decisionBranches) &&
       (isEmpty(similarQuestionAnswers) || !isShowSimilarQuestionAnswers)
    ) {
      return Promise.resolve(process())
    }

    const dbPromises = decisionBranches.map(db => (
      api.createChatworkDecisionBranch({
        decisionBranchId: db.id,
        chatId,
        roomId,
        fromAccountId
      })
    ))
    const dbPromise = new Promise((resolve, reject) => {
      Promise.all(dbPromises).then(responses => {
        decisionBranchLinkList = responses
          .map(res => pick(res.data.chatworkDecisionBranch, ['accessToken', 'decisionBranchBody']))
          .map(data => `・${data.decisionBranchBody} ${MYOPE_API_URL}/cwdb/${data.accessToken}`)
          .join('\n')
        resolve()
      }).catch(err => {
        console.error(err)
        reject()
      })
    })

    const sqaPromises = similarQuestionAnswers.filter(sqa => (
      !isEmpty(sqa.question) && sqa.question !== 'どれにも該当しない'
    )).map(sqa => (
      api.createChatworkSimilarQuestionAnswer({
        chatId,
        roomId,
        fromAccountId,
        questionAnswerId: sqa.id
      })
    ))
    const sqaPromise = new Promise((resolve, reject) => {
      Promise.all(sqaPromises).then(responses => {
        similarQuestionAnswersLinkList = responses
          .map(res => pick(res.data.chatworkSimilarQuestionAnswer, ['accessToken', 'question']))
          .map(data => `・${data.question} ${MYOPE_API_URL}/cwsqa/${data.accessToken}`)
          .join('\n')
        resolve()
      }).catch(err => {
        console.error(err)
        reject()
      })
    })

    return Promise.all([dbPromise, sqaPromise])
      .then(() => { process() })
  }

  reqHeaders () {
    return { 'X-ChatWorkToken': this.apiToken }
  }
}

module.exports = ChatworkBot