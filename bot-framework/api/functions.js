const axios = require('axios')

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

module.exports.fetchMessages = ({
  botToken,
  guestKey,
  olderThanId,
  perPage,
}, config = {}) => (
  axios.get(`/api/bots/${botToken}/chat_messages.json`, Object.assign({},
    config,
    {
      params: {
        older_than_id: olderThanId || 0,
        guest_key: guestKey,
        per_page: perPage,
      }
    }
  )
))

module.exports.createMessage = ({
  botToken,
  guestKey,
  message,
  questionAnswerId
}, config = {}) => {
  if (questionAnswerId === -1) {
    return axios.post(`/api/bots/${botToken}/chat_failed_messages.json`, {
      guest_key: guestKey,
      message
    }, config)
  }
  else {
    return axios.post(`/api/bots/${botToken}/chat_messages.json`, {
      guest_key: guestKey,
      message,
      question_answer_id: questionAnswerId
    }, config)
  }
}

module.exports.createChoice = ({
  botToken,
  guestKey,
  choiceId
}, config = {}) => (
  axios.post(`/api/bots/${botToken}/chat_choices.json`, {
    id: choiceId,
    guest_key: guestKey
  }, config)
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

module.exports.createRating = ({
  botToken,
  guestKey,
  messageId,
  ratingLevel,
}, config = {}) => (
  axios.post(`/api/bots/${botToken}/chat_messages/${messageId}/rating.json`, {
    guest_key: guestKey,
    rating: { level: ratingLevel },
  }, config)
)

module.exports.createGuestUser = ({
  name,
  email
}, config = {}) => (
  axios.post('/api/guest_users.json', {
    guest_user: {
      name,
      email
    }
  }, config)
)

module.exports.fetchQuestionAnswers = ({ botToken }, config = {}) => (
  axios.get(`/api/bots/${botToken}/question_answers`, config)
)

module.exports.moveInitialSelectionHigher = ({
  botToken,
  id,
}, config = {}) => (
  axios.put(`/api/bots/${botToken}/initial_selections/${id}/move_higher`, {}, config)
)

module.exports.moveInitialSelectionLower = ({
  botToken,
  id,
}, config = {}) => (
  axios.put(`/api/bots/${botToken}/initial_selections/${id}/move_lower`, {}, config)
)
