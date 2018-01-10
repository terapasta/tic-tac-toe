import get from 'lodash/get'
import { handleActions } from 'redux-actions'

import { fetchInitialQuestions } from '../ActionCreators'

export default handleActions({
  [fetchInitialQuestions]: (state, action) => {
    const { error, payload } = action;

    if (error) {
      console.error(payload);
      return state;
    }

    const questionAnswers = get(payload, "data.questionAnswers");
    return questionAnswers;
  }
}, []);
