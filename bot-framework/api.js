const axios = require('axios')
const { MYOPE_API_URL } = require('./env')

axios.defaults.baseURL = MYOPE_API_URL

module.exports.fetchPublicBot = ({ botToken }) => (
  axios.get(`/api/public_bots/${botToken}.json`)
)

module.exports.fetchLineCredential = ({ botToken }) => (
  axios.get(`/api/bots/${botToken}/line_credential.json`)
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