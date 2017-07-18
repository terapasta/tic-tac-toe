import { handleActions } from 'redux-actions';
import assign from 'lodash/assign';

import {
  succeedCreateDecisionBranch,
  failedCreateDecisionBranch,

  succeedUpdateDecisionBranch,
  failedUpdateDecisionBranch,

  succeedDeleteDecisionBranch,
  failedDeleteDecisionBranch,
} from '../action-creators/decision-branch';

const initialState = {};
console.log(succeedCreateDecisionBranch)

export default handleActions({
  [succeedCreateDecisionBranch]: (state, action) => {
    const { decisionBranch } = action.payload;
    return assign({}, state, {
      [decisionBranch.id]: decisionBranch
    });
  },
  [failedCreateDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedUpdateDecisionBranch]: (state, action) => {
    const { decisionBranch } = action.payload
    return assign({}, state, {
      [decisionBranch.id]: decisionBranch
    });
  },
  [failedUpdateDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedDeleteDecisionBranch]: (state, action) => {
    const { id } = action.payload;
    delete state[id];
    return state;
  },
  [failedDeleteDecisionBranch]: (state, action) => {
    return state;
  },
}, initialState);
