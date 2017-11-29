const axios = require('axios')
const { MYOPE_API_URL } = require('./env')

module.exports.createChat = ({
  botToken,
  uid,
  service_type,
  name
}) => (
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chats.json`, {
    service_type,
    uid: 'hogehoge',
    name
  })
)

module.exports.createMessage = ({
  botToken,
  guestKey,
  message
}) => (
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chat_messages.json`, {
    guest_key: guestKey,
    message
  })
)

module.exports.createChoice = ({
  botToken,
  guestKey,
  choiceId
}) => (
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chat_choices/${choiceId}.json`, {
    guest_key: guestKey
  })
)