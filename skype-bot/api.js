const axios = require('axios')

const { MYOPE_API_URL } = process.env

export const createChat = ({
  token,
  uid,
  service_type,
  name
}) => (
  axios.post(`${MYOPE_API_URL}/api/chats`, {
    token,
    uid,
    service_type,
    name
  })
)

export const createMessage = ({
  token,
  uid,
  service_type,
  message
}) => (
  axios.post(`${MYOPE_API_URL}/api/chats/messages`, {
    token,
    uid,
    service_type,
    message
  })
)