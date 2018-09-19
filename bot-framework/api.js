const axios = require('axios')
const { MYOPE_API_URL } = require('./env')

axios.defaults.baseURL = MYOPE_API_URL

module.exports.fetchPublicBot = ({ botToken }) => (
  axios.get(`/api/public_bots/${botToken}.json`)
)

module.exports.fetchLineCredential = ({ botToken }) => (
  axios.get(`/api/bots/${botToken}/line_credential.json`)
)

module.exports.fetchChatworkCredential = ({ botToken }) => (
  axios.get(`/api/bots/${botToken}/chatwork_credential.json`)
)

module.exports.fetchMicrosoftCredential = ({ botToken }) => (
  axios.get(`/api/bots/${botToken}/microsoft_credential.json`)
)

module.exports.fetchSlackCredential = ({ botToken }) => (
  axios.get(`/api/bots/${botToken}/slack_credential.json`)
)

module.exports.fetchChat = ({
  botToken,
  chatId
}) => (
  axios.get(`/api/bots/${botToken}/chats/${chatId}.json`)
)

module.exports.createChat = ({
  botToken,
  uid,
  service_type,
  name
}) => (
  axios.post(`/api/bots/${botToken}/chats.json`, {
    service_type,
    uid,
    name
  })
)

module.exports.createMessage = ({
  botToken,
  guestKey,
  message,
  questionAnswerId
}) => (
  axios.post(`/api/bots/${botToken}/chat_messages.json`, {
    guest_key: guestKey,
    message,
    question_answer_id: questionAnswerId
  })
)

module.exports.createChoice = ({
  botToken,
  guestKey,
  choiceId
}) => (
  axios.post(`/api/bots/${botToken}/chat_choices.json`, {
    id: choiceId,
    guest_key: guestKey
  })
)

module.exports.createChatworkDecisionBranch = ({
  chatId,
  roomId,
  fromAccountId,
  decisionBranchId
}) => (
  axios.post(`/api/cwdb.json`, {
    chatwork_decision_branch: {
      chat_id: chatId,
      room_id: roomId,
      from_account_id: fromAccountId,
      decision_branch_id: decisionBranchId
    }
  })
)

module.exports.createChatworkSimilarQuestionAnswer = ({
  chatId,
  roomId,
  fromAccountId,
  questionAnswerId
}) => (
  axios.post(`/api/cwsqa.json`, {
    chatwork_similar_question_answer: {
      chat_id: chatId,
      room_id: roomId,
      from_account_id: fromAccountId,
      question_answer_id: questionAnswerId
    }
  })
)

