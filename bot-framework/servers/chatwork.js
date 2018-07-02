const api = require('../api')
const Base = require('./base')
const ChatworkBot = require('../bots/chatwork')

class Chatwork extends Base {
  get name () { return 'chatwork' }

  constructor () {
    super()
    this.chatListeners = [
      this.beforeSignatureValidation.bind(this),
      this.handleEvents.bind(this)
    ]
    this.decisionBranchListeners = [
      this.handleDecisionBranch.bind(this)
    ]
  }

  beforeSignatureValidation (req, res, next) {
    const { botToken } = req.body
    this.fetchCredential(botToken).then(credential => {
      const { webhookToken, apiToken } = credential
      req.chatworkBot = new ChatworkBot(apiToken)

      const validator = this.createSignatureValidator('x-chatworkwebhooksignature', Buffer.from(webhookToken, 'base64'))
      validator(req, res, next)
    }).catch(console.error)
  }

  fetchCredential (botToken) {
    return new Promise((resolve, reject) => {
      api.fetchChatworkCredential({ botToken }).then(res => {
        const credential = res.data['bot::ChatworkCredential']
        resolve(credential)
      }).catch(err => {
        console.error(err)
        reject(err)
      })
    })
  }

  handleEvents (req, res, next) {
    if (req.body.webhook_event_type !== 'mention_to_me') {
      return
    }
    req.chatworkBot.handleEvent(req.body)
  }

  handleDecisionBranch (req, res, next) {
    const { botToken } = req.params
    this.fetchCredential(botToken).then(credential => {
      const { apiToken } = credential
      req.chatworkBot = new ChatworkBot(apiToken)
      req.chatworkBot.handleDecisionBranch(req)
    }).catch(console.error)
  }
}

module.exports = Chatwork
