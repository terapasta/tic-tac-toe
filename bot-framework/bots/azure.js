const path = require('path')
const get = require('lodash.get')
const isEmpty = require('is-empty')
const {
  UniversalBot,
  ChatConnector,
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
  MicrosoftAppId,
  MicrosoftAppPassword,
} = require('../env')

const {
  createChat,
  createMessage,
  createChoice
} = require('../api')

const service_type = 'azure'

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


const handleAnswerMessage = ({ session, res }) => {
  // NOTE:
  // 回答の場合は mension である必要はないので
  // shouldReply によるチェックは不要

  const body = get(res, 'data.message.body')
  const decisionBranches = get(res, 'data.message.questionAnswer.decisionBranches')
  const childDecisionBranches = get(res, 'data.message.childDecisionBranches')
  const similarQuestionAnswers = get(res, 'data.message.similarQuestionAnswers')
  const answerFiles = get(res, 'data.message.answerFiles', [])
  const isShowSimilarQuestionAnswers = get(res, 'data.message.isShowSimilarQuestionAnswers')

  // 「\r\n」で改行を行なってくれないので、「\n\n」に置き換える
  const replaced = body.replace(/\r\n/g, '\n\n')
  const message = appendReplier(session, replaced);

  if (!isEmpty(decisionBranches) || !isEmpty(childDecisionBranches)) {
    sendMessageWithAttachments(session, message, answerFiles)
    // Disaptch decisionBranches Dialog

    session.replaceDialog('decisionBranches', {
      decisionBranches: decisionBranches || childDecisionBranches,
      isSuggestion: false
    });
  } else if (!isEmpty(similarQuestionAnswers) && isShowSimilarQuestionAnswers) {
    sendMessageWithAttachments(session, message, answerFiles)
    // Disaptch decisionBranches Dialog as suggestion
    return session.beginDialog('decisionBranches', {
      decisionBranches: similarQuestionAnswers,
      isSuggestion: true
    })
  } else {
    sendMessageWithAttachments(session, message, answerFiles)
  }
}

const sendMessageWithAttachments = (session, message, answerFiles) => {
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

const defaultDialogHandler = (session, args) => {
  // 反応する必要のないイベントも流れてくるので、制御する
  if (!shouldReply(session)) {
    return;
  }

  let { botToken } = session.message
  const { source } = session.message
  const { id, uid, name } = session.message.user
  const _uid = resolveUid({ source, id, uid })
  const service_type = source === 'webchat' ? 'msteams' : source
  const message = parseMessageBody(session)

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
      handleAnswerMessage({ session, res })
    })
  )).catch((err) => {
    console.error(err)
    session.send('エラーが発生しました: ' + err.message)
  })
}

const getDecisionBranchStepHandlers = () => {
  return [
    // Show choices
    (session, { message, decisionBranches, isSuggestion }) => {
      session.userData.decisionBranches = decisionBranches
      session.userData.isSuggestion = isSuggestion

      const attrName = isSuggestion ? 'question' : 'body'
      const choices = decisionBranches.reduce((acc, db) => {
        acc[db[attrName]] = db
        return acc
      }, {})
      let _message = isSuggestion ? 'こちらの質問ではないですか？<br/>' : '回答を選択して下さい'
      _message = !isEmpty(message) ? `${message}<br/>` : _message

      Prompts.choice(session, _message/* + "※半角数字で解答して下さい"*/, choices, {
        listStyle: ListStyle.button,
        maxRetries: isSuggestion ? 0 : 1
      })
    },
    // Handle selected choice
    (session, results) => {
      const { source } = session.message
      const { id, uid, name } = session.message.user
      const { decisionBranches, isSuggestion } = session.userData
      const selected = decisionBranches[get(results, 'response.index')]
      const _uid = resolveUid({ source, id, uid })

      const botToken = BOT_TOKEN;

      if (selected == null) {
        session.endDialog()
        return defaultDialogHandler(session)
      }

      session.userData = {}
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
            message: selected.question,
            questionAnswerId: selected.id,
          }).then((res) => {
            session.endDialog()
            handleAnswerMessage({ session, res })
          })
        } else {
          createChoice({
            botToken,
            guestKey,
            choiceId: selected.id
          }).then((res) => {
            session.endDialog()
            handleAnswerMessage({ session, res })
          })
        }
      }).catch((err) => {
        console.error(err)
        session.send('エラーが発生しました: ' + err.message)
      })
    }
  ]
}

const shouldReply = (session) => {
  // サービスごとに API からのレスポンスが異なるので、ここで調整する
  switch (session.message.source) {
    case 'slack':
      return shouldReplyInSlack(session);
    default:
      return true;
  }
}

const parseMessageBody = (session) => {
  return session
         .message
         .text
         .replace(/<at>.+<\/at>/g, '')
         .replace(/^@[^\s]+/g, '')
         .trim();
}

const appendReplier = (session, message) => {
  switch (session.message.source) {
    case 'slack':
      const userAndTeamId = session.message.user.id;
      const userId = userAndTeamId.split(':')[0];
      return `<@${userId}> ` + message;
    default:
      return message;
  }
}

const shouldReplyInSlack = (session) => {
  // slack の場合はメンションと IM のみ返答する
  return isSlackMentioned(session) || isSlackIM(session);
}

const isSlackMentioned = (session) => {
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

const isSlackIM = (session) => {
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


const inMemoryStorage = new MemoryBotStorage();

// NOTE:
// Azure上の App Service で環境変数を指定できるので、API に問い合わせる必要がない
// そもそも Bot Service上にデプロイされたボットが通信するためには
// MicrosoftAppId と MicrosoftAppPassword が必要なので、
// APIサーバーに問い合わせるというシステム設計だと動かない気がする？
// （そんなに真面目に検討していないので、必要なら再検討）
const connector = new ChatConnector({
  appId: MicrosoftAppId,
  appPassword: MicrosoftAppPassword,
});

let bot = new UniversalBot(connector, {
  localizerSettings: {
    defaultLocale: 'ja'
  }
}).set('storage', inMemoryStorage);

bot.dialog('/', [defaultDialogHandler]);
bot.dialog('decisionBranches', getDecisionBranchStepHandlers());

module.exports = connector;