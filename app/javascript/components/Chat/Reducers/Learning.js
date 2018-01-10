import assign from 'lodash/assign'
import { handleActions } from 'redux-actions'

import { LearningStatus } from '../Constants'
import {
  startLearning,
  getLearningStatus,
} from '../ActionCreators'

export default handleActions({
  [startLearning]: (state, action) => {
    return assign({}, state, {
      status: LearningStatus.Processing,
    })
  },

  [getLearningStatus]: (state, action) => {
    const { error, payload } = action

    if (error) {
      console.error(payload)
      return state
    }

    return assign({}, state, {
      status: payload.data.learning_status,
    })
  },
}, { status: null })
