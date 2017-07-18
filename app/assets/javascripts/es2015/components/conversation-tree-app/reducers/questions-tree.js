import { handleActions } from 'redux-actions';

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
    const { id, decisionBranches } = action.payload.questionAnswer;
    const node = { id, decisionBranches };
    return [node].concat(state.concat());
  },
  [failedCreateQuestion]: (state, action) => {
    return state;
  },

  [succeedUpdateQuestion]: (state, action) => {
    return state;
  },
  [failedUpdateQuestion]: (state, action) => {
    return state;
  },

  [succeedDeleteQuestion]: (state, action) => {
    return state;
  },
  [failedDeleteQuestion]: (state, action) => {
    return state;
  },
}, initialState);
