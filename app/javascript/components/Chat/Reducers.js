import { combineReducers } from 'redux'

import messages from './Reducers/Messages'
import form from './Reducers/Form'
import learning from './Reducers/Learning'
import learnings from './Reducers/Learnings'
import readMore from './Reducers/ReadMore'
import initialQuestions from './Reducers/InitialQuestions'

function through(state = null) {
  return state
}

const Reducers = combineReducers({
  messages,
  form,
  learning,
  learnings,
  readMore,
  token: through,
  isAdmin: through,
  isManager: through,
  flashMessage: through,
  isRegisteredGuestUser: through,
  isEnableGuestUserRegistration: through,
  initialQuestions,
})

export default Reducers
