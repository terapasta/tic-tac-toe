const axios = require('axios')
const { MYOPE_API_URL } = require('./env')

module.exports.fetchPublicBot = ({ botToken }) => (
  axios.get(`${MYOPE_API_URL}/api/public_bots/${botToken}.json`)
)

module.exports.createChat = ({
  botToken,
  uid,
  service_type,
  name
}) => (
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chats.json`, {
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
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chat_messages.json`, {
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
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chat_choices.json`, {
    id: choiceId,
    guest_key: guestKey
  })
)