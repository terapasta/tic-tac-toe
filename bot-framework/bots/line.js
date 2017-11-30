class LineBot {
  constructor(lineClient) {
    this.lineClient = lineClient
    this.handleEvent = this.handleEvent.bind(this)
  }

  handleEvent (botToken, event) {
    if (event.type !== 'message' || event.message.type !== 'text') {
      // TODO 回答不可
      return Promise.resolve(null)
    }

    return this.lineClient.replyMessage(event.replyToken, {
      type: 'text',
      text: `山彦 ${event.message.text} ${botToken}`
    });
  }
}

module.exports = LineBot