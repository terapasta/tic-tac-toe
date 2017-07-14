import assign from 'lodash/assign';
import includes from 'lodash/includes';
import bindAll from 'lodash/bindAll';
import { handleActions } from "redux-actions";

import {
  openQuestionNode,
  closeQuestionNode,
  toggleQuestionNode,

  openAnswerNode,
  closeAnswerNode,
  toggleAnswerNode,

  openDecisionBranchNode,
  closeDecisionBranchNode,
  toggleDecisionBranchNode,
} from '../action-creators';

const initialState = {
  questionIds: [],
  answerIds: [],
  decisionBranchIds: [],
};

function makeHandlers(type) {
  const key = `${type}Ids`;

  return {
    open(state, action) {
      const val = state[key].concat([action.payload.id]);
      return assign({}, state, { [key]: val });
    },

    close(state, action) {
      const val = state[key].filter((id) => id !== action.payload.id);
      return assign({}, state, { [key]: val });
    },

    toggle(state, action) {
      if (includes(state[key], action.payload.id)) {
        return this.close(state, action);
      } else {
        return this.open(state, action);
      }
    },
  };
}

const questionHandlers = makeHandlers('question');
const answerHandlers = makeHandlers('answer');
const decisionBranchHandlers = makeHandlers('decisionBranch');
bindAll(questionHandlers, ['open', 'close', 'toggle']);
bindAll(answerHandlers, ['open', 'close', 'toggle']);
bindAll(decisionBranchHandlers, ['open', 'close', 'toggle']);

export default handleActions({
  [openQuestionNode]: questionHandlers.open,
  [closeQuestionNode]: questionHandlers.close,
  [toggleQuestionNode]: questionHandlers.toggle,

  [openAnswerNode]: answerHandlers.open,
  [closeAnswerNode]: answerHandlers.close,
  [toggleAnswerNode]: answerHandlers.toggle,

  [openDecisionBranchNode]: decisionBranchHandlers.open,
  [closeDecisionBranchNode]: decisionBranchHandlers.close,
  [toggleDecisionBranchNode]: decisionBranchHandlers.toggle,
}, initialState);
