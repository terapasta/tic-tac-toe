const path = require('path')
const get = require('lodash.get')
const isEmpty = require('is-empty')
const {
  UniversalBot,
  Prompts,
  ListStyle,
  Message,
  AttachmentLayout,
  HeroCard,
  CardImage,
  CardAction,
  MemoryBotStorage,
} = require('botbuilder')

const {
  NODE_ENV,
  BOT_TOKEN,
} = require('../env')

const {
  createChat,
  createMessage,
  createChoice
} = require('../api')

const service_type = 'skype'

const resolveUid = ({ source, id, uid }) => {
  switch (source) {
    case 'slack':
    case 'webchat':
    case 'msteams':
    case 'emulator': // Microsfot製 botframework-emulator（開発用）
    case 'azure':
      return id
    default:
      return uid
  }
}

class Bot {
  constructor(connector) {
    this.connector = connector

    // NOTE:
    // in memory storage を使わないと動かなくなった
    //
    // stackoverflow
    // https://stackoverflow.com/questions/51823661/bot-framework-webchat-failure-405-method-not-allowed
    //
    // MS docs
    // https://docs.microsoft.com/en-us/azure/bot-service/nodejs/bot-builder-nodejs-state?view=azure-bot-service-3.0
    //
    const inMemoryStorage = new MemoryBotStorage();
    this.bot = new UniversalBot(this.connector, {
      localizerSettings: {
        defaultLocale: 'ja'
      }
    }).set('storage', inMemoryStorage)

    this.bot.dialog('/', this.handleDefaultDialog.bind(this))
    this.bot.dialog('decisionBranches', this.handleDecisionBranchesDialogSteps())
  }

  handleAnswerMessage({ session, res }) {
    // NOTE:
    // 回答の場合は mension である必要はないので
    // shouldReply によるチェックは不要

    const body = get(res, 'data.message.body')
    const decisionBranches = get(res, 'data.message.questionAnswer.decisionBranches')
    const childDecisionBranches = get(res, 'data.message.childDecisionBranches')
    const similarQuestionAnswers = get(res, 'data.message.similarQuestionAnswers')
    const answerFiles = get(res, 'data.message.answerFiles', [])
    const isShowSimilarQuestionAnswers = get(res, 'data.message.isShowSimilarQuestionAnswers')

    const message = this.appendReplier(session, body);

    if (!isEmpty(decisionBranches) || !isEmpty(childDecisionBranches)) {
      this.sendMessageWithAttachments(session, message, answerFiles)
      // Disaptch decisionBranches Dialog
      return session.beginDialog('decisionBranches', {
        decisionBranches: decisionBranches || childDecisionBranches,
        isSuggestion: false
      })
    } else if (!isEmpty(similarQuestionAnswers) && isShowSimilarQuestionAnswers) {
      this.sendMessageWithAttachments(session, message, answerFiles)
      // Disaptch decisionBranches Dialog as suggestion
      return session.beginDialog('decisionBranches', {
        decisionBranches: similarQuestionAnswers,
        isSuggestion: true
      })
    } else {
      this.sendMessageWithAttachments(session, message, answerFiles)
    }
  }

  handleDefaultDialog(session) {
    // 反応する必要のないイベントも流れてくるので、制御する
    if (!this.shouldReply(session)) {
      return;
    }

    let { botToken } = session.message
    const { source } = session.message
    const { id, uid, name } = session.message.user
    const _uid = resolveUid({ source, id, uid })
    const service_type = source === 'webchat' ? 'msteams' : source
    const message = this.parseMessageBody(session)

    // Azure上の bot service を使ってデプロイした場合は、環境変数で指定する
    if (botToken === undefined && BOT_TOKEN) {
      botToken = BOT_TOKEN
    }

    session.sendTyping()

    // POST /api/bots/:token/chats.json
    createChat({
      botToken,
      uid: _uid,
      name,
      service_type
    }).then((res) => (
      // POST /api/bots/:token/chats/:id/messages.json
      createMessage({
        botToken,
        guestKey: res.data.chat.guestKey,
        message
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
        let _message = isSuggestion ? 'こちらの質問ではないですか？<br/>' : '回答を選択して下さい'
        _message = !isEmpty(message) ? `${message}<br/>` : _message

        Prompts.choice(session, _message/* + "※半角数字で解答して下さい"*/, choices, {
          listStyle: ListStyle.button,
          maxRetries: isSuggestion ? 0 : 1
        })
      },
      // Handle selected choice
      (session, results) => {
        const { botToken, source } = session.message
        const { id, uid, name } = session.message.user
        const { decisionBranches, isSuggestion } = session.privateConversationData
        const selected = decisionBranches[get(results, 'response.index')]
        const _uid = resolveUid({ source, id, uid })

        if (selected == null) {
          session.endDialog()
          return this.handleDefaultDialog(session)
        }

        session.privateConversationData = {}
        session.sendTyping()

        createChat({
          botToken,
          uid: _uid,
          name,
          service_type: source
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
        .images([CardImage.create(session, it.file.url)])
        .buttons([CardAction.openUrl(session, it.file.url, '画像を開く')])))

    const otherFiles = answerFiles
      .filter(it => !/image/.test(it.fileType))
      .map(it => (new HeroCard(session)
        .title(decodeURIComponent(path.basename(it.file.url)))
        .buttons([CardAction.openUrl(session, it.file.url, 'ダウンロード')])))

    const msg = new Message(session)
      .attachmentLayout(AttachmentLayout.carousel)
      .attachments(imageFiles.concat(otherFiles))

    session.send(message)
    session.send(msg)
  }

  parseMessageBody(session) {
    return session
           .message
           .text
           .replace(/<at>.+<\/at>/g, '')
           .replace(/^@[^\s]+/g, '')
           .trim();
  }

  appendReplier(session, message) {
    switch (session.message.source) {
      case 'slack':
        const userAndTeamId = session.message.user.id;
        const userId = userAndTeamId.split(':')[0];
        return `<@${userId}> ` + message;
    }
    return message;
  }

  shouldReply(session) {
    // サービスごとに API からのレスポンスが異なるので、ここで調整する
    switch (session.message.source) {
      case 'slack':
        return this.shouldReplyInSlack(session);
    }

    return true;
  }

  shouldReplyInSlack(session) {
    // slack の場合はメンションと IM のみ返答する
    return this.isSlackMentioned(session) || this.isSlackIM(session);
  }

  isSlackMentioned(session) {
    // session が適切な変数でない場合、false
    if (!session.message) {
      return false;
    }

    // メッセージに含まれる entity から botId を検出
    if (
      !session.message.entities ||
      !(session.message.entities.length > 0) ||
      !session.message.entities[0].mentioned ||
      !session.message.entities[0].mentioned.id
    ) {
      return false;
    }

    // メッセージに含まれるボット情報から botId を検出
    if (
      !session.message.address ||
      !session.message.address.bot ||
      !session.message.address.bot.id
    ) {
      return false;
    }

    // エンティティとボット情報の ID が等しければ、bot への返信
    return session.message.entities[0].mentioned.id === session.message.address.bot.id;
  }

  isSlackIM(session) {
    // session が適切な変数でない場合、false
    if (
      !session.message ||
      !session.message.sourceEvent ||
      !session.message.sourceEvent.SlackMessage ||
      !session.message.sourceEvent.SlackMessage.event ||
      !session.message.sourceEvent.SlackMessage.event.channel_type
    ) {
      return false;
    }

    // channel_type が im ならばボットへの直接的なメッセージ
    // （他の人との im での会話は取得できないはずなので、id を確認する必要はない）
    return session.message.sourceEvent.SlackMessage.event.channel_type === 'im';
  }
}

module.exports = Bot