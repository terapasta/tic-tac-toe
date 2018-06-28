const get = require('lodash.get')
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
  constructor(apiToken) {
    this.apiToken = apiToken
  }

  handleEvent (reqBody) {
    const { botToken, webhook_event: { from_account_id, body } } = reqBody

    this.fetchUsers().then(users => {
      const user = users.filter(it => it.account_id === from_account_id)[0]
      if (user === undefined) { return }

      let chatId

      api.createChat({
        botToken,
        uid: from_account_id,
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
        // const similarQuestionAnswers = get(res, 'data.similarQuestionAnswers')

        this.sendReply(reqBody, user.name, body, answerFiles, mergedDecisionBranches, chatId)
      }).catch(console.error)
    })
  }

  handleDecisionBranch (req) {
    console.log(req)
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

  sendReply (reqBody, userName, text, answerFiles, decisionBranches, chatId) {
    const roomId = reqBody.webhook_event.room_id
    const fromAccountId = reqBody.webhook_event.from_account_id
    let decisionBranchLinkList

    const process = () => {
      const url = `${BASE_URL}/rooms/${roomId}/messages`
      const answerFileUrls = (answerFiles || []).map(it => s3 + it.file.url).join('\n')
      const answerFileText = answerFileUrls.length > 0 ? `\n\n<添付ファイル>\n${answerFileUrls}` : ''
      let body = `[To:${fromAccountId}] ${userName}さん\n${text}${answerFileText}`
      if (!isEmpty(decisionBranchLinkList)) {
        body += `\n\n${decisionBranchLinkList}`
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
        // console.log(res)
      })
    }

    if (isEmpty(decisionBranches)) {
      return process()
    }

    const promises = decisionBranches.map(db => (
      api.createChatworkDecisionBranch({
        decisionBranchId: db.id,
        chatId,
        roomId,
        fromAccountId
      })
    ))

    Promise.all(promises).then(responses => {
      decisionBranchLinkList = responses
        .map(res => [
          res.data.chatworkDecisionBranch.accessToken,
          res.data.chatworkDecisionBranch.decisionBranchBody
        ])
        .map(data => `- ${data[1]} ${MYOPE_API_URL}/api/cwdb/${data[0]}`)
        .join('\n')

      process()
    }).catch(err => {
      console.error(err)
    })
  }

  reqHeaders () {
    return { 'X-ChatWorkToken': this.apiToken }
  }
}

module.exports = ChatworkBot