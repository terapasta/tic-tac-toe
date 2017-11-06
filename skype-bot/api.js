const axios = require('axios')

const { MYOPE_API_URL } = process.env

module.exports.createChat = ({
  botToken,
  uid,
  service_type,
  name
}) => (
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chats`, {
    service_type,
    uid,
    name
  })
)

module.exports.createMessage = ({
  botToken,
  guestKey,
  message
}) => (
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chat_messages`, {
    guest_key: guestKey,
    message
  })
)

module.exports.createChoice = ({
  botToken,
  guestKey,
  choiceId
}) => (
  axios.post(`${MYOPE_API_URL}/api/bots/${botToken}/chat_choices/${choiceId}`, {
    guest_key: guestKey
  })
)