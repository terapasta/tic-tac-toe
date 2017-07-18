import { handleActions } from 'redux-actions';
import assign from 'lodash/assign';

import {
  succeedCreateQuestion,
  failedCreateQuestion,

  succeedUpdateQuestion,
  failedUpdateQuestion,

  succeedDeleteQuestion,
  failedDeleteQuestion,
} from '../action-creators/question';

const initialState = {};

export default handleActions({
  [succeedCreateQuestion]: (state, action) => {
    const { questionAnswer } = action.payload;
    return assign({}, state, { [questionAnswer.id]: questionAnswer });
  },
  [failedCreateQuestion]: (state, action) => {
    return state;
  },

  [succeedUpdateQuestion]: (state, action) => {
    const { questionAnswer } = action.payload;
    return assign({}, state, { [questionAnswer.id]: questionAnswer });
  },
  [failedUpdateQuestion]: (state, action) => {
    return state;
  },

  [succeedDeleteQuestion]: (state, action) => {
    const { id } = action.payload;
    delete state[id];
    return state;
  },
  [failedDeleteQuestion]: (state, action) => {
    return state;
  },
}, initialState);
