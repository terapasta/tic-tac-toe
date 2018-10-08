const crypto = require('crypto')
const isPlainObject = require('lodash.isplainobject')
const cloneDeep = require('lodash.clonedeep')

class Base {
  constructor (...chatListeners) {
    this.chatListeners = chatListeners
  }

  get name () {
    throw new Error('You must implement getter `name`')
  }

  mapRoute (app) {
    app.get(`/${this.name}/healthcheck`, (req, res) => res.send('OK'))

    // NOTE:
    // Azure の Bot Service を使う場合、/api/messages をエントリポイントとして指定する必要がある
    // slack に限らず、他のサービスも Azure を介して連携する場合には必要なはずだが、
    // ひとまず slack だけ追加しておく
    if (this.name === 'slack') {
      app.post('/', this.reqBodyMiddleware.bind(this), ...this.chatListeners);
      app.post('/api/messages',
        this.reqBodyMiddleware.bind(this),
        ...this.chatListeners
      );
    }

    app.post(`/${this.name}/:botToken`,
      this.reqBodyMiddleware.bind(this),
      ...this.chatListeners
    )

    if (this.name === 'chatwork') {
      app.post(`/${this.name}/:botToken/:chatId/decisionBranch`, ...this.decisionBranchListeners)
      app.post(`/${this.name}/:botToken/:chatId/similarQuestionAnswer`, ...this.similarQuestionAnswerListeners)
    }
  }

  reqBodyMiddleware (req, res, next) {
    if (req.body) {
      this.passToChatListener(req, res, next)
    } else {
      let requestData = ''
      req.on('data', chunk => { requestData += chunk })
      req.on('end', () => {
        req.body = requestData
        this.passToChatListener(req, res, next)
      })
    }
  }

  passToChatListener (req, res, next) {
    req.body = Object.assign({}, req.body, {
      botToken: req.params.botToken
    })
    next(req, res)
  }

  /**
   * HMAC-SHA256アルゴリズム等の署名がある場合にイベントハンドラの前段で使用する
   */
  createSignatureValidator (signatureName, secretKey, algorithm = null, encoding = null) {
    return (req, res, next) => {
      const signature = req.headers[signatureName]
      const strBody = this.sanitizeReqBody(cloneDeep(req.body))
      const isValidSignature = this.validateSignature({
        signature, secretKey, strBody, algorithm, encoding
      })

      if (!isValidSignature) {
        console.error(`invalid ${signatureName}`)
        return next(new Error(`invalid ${signatureName}`))
      }
      next(req, res)
    }
  }

  /**
   * request bodyからbotTokenパラメーターを削除したjson文字列を返す
   */
  sanitizeReqBody (body) {
    let parsedBody, strBody
    if (isPlainObject(body)) {
      parsedBody = body
    } else {
      strBody = Buffer.isBuffer(body) ? body.toString() : body
      parsedBody = JSON.parse(strBody)
    }
    delete parsedBody.botToken
    return JSON.stringify(parsedBody)
  }

  /**
   * 署名を検証する
   * デフォルトはHMAC-SHA256アルゴリズムのhashをbase64エンコード
   */
  validateSignature ({ signature, secretKey, strBody, algorithm, encoding }) {
    const verification = crypto
      .createHmac((algorithm || 'sha256'), secretKey)
      // .update(Buffer.from(strBody))
      .update(strBody)
      .digest(encoding || 'base64')
    return signature === verification
  }
}

module.exports = Base