const request = require('request')
const api = require('../api')

const {
  NODE_ENV
} = require('../env')

const s3 = NODE_ENV === 'development' ?
  'https://my-ope-assets-dev.s3.amazonaws.com' : ''
const BASE_URL = 'https://api.chatwork.com/v2'
const service_type = 'chatwork'

class ChatworkBot {
  constructor(apiToken) {
    this.apiToken = apiToken
  }

  handleEvent(reqBody) {
    const { botToken, webhook_event: { from_account_id, body } } = reqBody

    this.fetchUsers().then(users => {
      const user = users.filter(it => it.account_id === from_account_id)[0]
      if (user === undefined) { return }

      api.createChat({
        botToken,
        uid: from_account_id,
        service_type,
        name: user.name
      }).then(res => {
        const { guestKey } = res.data.chat
        return api.createMessage({
          botToken,
          guestKey,
          message: body
        })
      }).then(res => {
        const { body, answerFiles } = res.data.message
        this.sendReply(reqBody, user.name, body, answerFiles)
      }).catch(console.error)
    })
  }

  fetchUsers() {
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

  sendReply(reqBody, userName, text, answerFiles) {
    const { room_id, from_account_id } = reqBody.webhook_event
    const url = `${BASE_URL}/rooms/${room_id}/messages`
    const answerFileUrls = (answerFiles || []).map(it => s3 + it.file.url).join("\n")
    const answerFileText = answerFileUrls.length > 0 ? `\n\n<添付ファイル>\n${answerFileUrls}` : ''
    const formData = {
      body: `[To:${from_account_id}] ${userName}さん\n${text}${answerFileText}`
    }
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

  reqHeaders () {
    return { 'X-ChatWorkToken': this.apiToken }
  }
}

module.exports = ChatworkBot