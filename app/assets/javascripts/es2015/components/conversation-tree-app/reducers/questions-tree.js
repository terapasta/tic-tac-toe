import { handleActions } from 'redux-actions';

import {
  succeedCreateQuestion,
  failedCreateQuestion,

  succeedUpdateQuestion,
  failedUpdateQuestion,

  succeedDeleteQuestion,
  failedDeleteQuestion,
} from '../action-creators/question';

import {
  succeedCreateDecisionBranch,
  failedCreateDecisionBranch,

  succeedUpdateDecisionBranch,
  failedUpdateDecisionBranch,

  succeedDeleteDecisionBranch,
  failedDeleteDecisionBranch,
} from '../action-creators/decision-branch';

const initialState = [];

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

  // --------

  [succeedCreateDecisionBranch]: (state, action) => {
    const { decisionBranch } = action.payload;
    const { id, questionAnswerId } = decisionBranch;
    const newState = state.concat();
    newState.forEach((node) => {
      if (node.id === questionAnswerId) {
        node.decisionBranches.push({
          id,
          childDecisionBranches: [],
        });
      }
    });
    return newState;
  },
  [failedCreateDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedUpdateDecisionBranch]: (state, action) => {
    return state;
  },
  [failedUpdateDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedDeleteDecisionBranch]: (state, action) => {
    return state;
  },
  [failedDeleteDecisionBranch]: (state, action) => {
    return state;
  },
}, initialState);
