import { handleActions } from 'redux-actions';
import assign from 'lodash/assign';

import {
  succeedCreateDecisionBranch,
  failedCreateDecisionBranch,

  succeedUpdateDecisionBranch,
  failedUpdateDecisionBranch,

  succeedDeleteDecisionBranch,
  failedDeleteDecisionBranch,

  succeedCreateNestedDecisionBranch,
  failedCreateNestedDecisionBranch,

  succeedUpdateNestedDecisionBranch,
  failedUpdateNestedDecisionBranch,

  succeedDeleteNestedDecisionBranch,
  failedDeleteNestedDecisionBranch,

  succeedDeleteNestedDecisionBranchAnswer,
} from '../action-creators/decision-branch';

const initialState = {};

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

  // ---------------

  [succeedCreateNestedDecisionBranch]: (state, action) => {
    const { decisionBranch } = action.payload;
    return assign({}, state, {
      [decisionBranch.id]: decisionBranch,
    });
  },
  [failedCreateNestedDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedUpdateNestedDecisionBranch]: (state, action) => {
    const { decisionBranch } = action.payload;
    return assign({}, state, {
      [decisionBranch.id]: decisionBranch,
    });
  },
  [failedUpdateNestedDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedDeleteNestedDecisionBranch]: (state, action) => {
    const { id } = action.payload;
    delete state[id];
    return state;
  },
  [failedDeleteNestedDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedDeleteNestedDecisionBranchAnswer]: (state, action) => {
    const { decisionBranch } = action.payload;
    return assign({}, state, {
      [decisionBranch.id]: decisionBranch,
    });
  },
}, initialState);
