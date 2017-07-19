import { handleActions } from 'redux-actions';
import flatten from 'lodash/flatten';

import {
  succeedCreateQuestion,
  failedCreateQuestion,

  succeedUpdateQuestion,
  failedUpdateQuestion,

  succeedDeleteQuestion,
  failedDeleteQuestion,

  succeedDeleteAnswer,
} from '../action-creators/question';

import {
  succeedCreateDecisionBranch,
  failedCreateDecisionBranch,

  succeedUpdateDecisionBranch,
  failedUpdateDecisionBranch,

  succeedDeleteDecisionBranch,
  failedDeleteDecisionBranch,

  succeedCreateNestedDecisionBranch,
  failedCreateNestedDecisionBranch,

  succeedDeleteNestedDecisionBranch,
  failedDeleteNestedDecisionBranch,

  succeedDeleteNestedDecisionBranchAnswer,
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
    const { id } = action.payload;
    const newState = state.filter(node => node.id !== id);
    return newState;
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
    const newState = state.concat();
    const { questionId, id } = action.payload;
    newState.forEach((node) => {
      if (node.id === questionId) {
        node.decisionBranches = node.decisionBranches.filter(db => db.id !== id);
      }
    });
    return newState;
  },
  [failedDeleteDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedCreateNestedDecisionBranch]: (state, action) => {
    const { decisionBranch } = action.payload;
    const { parentDecisionBranchId } = decisionBranch;
    const newState = state.concat();
    findDecisionBranchFromTree(newState, parentDecisionBranchId, (db) => {
      db.childDecisionBranches.push({
        id: decisionBranch.id,
        childDecisionBranches: [],
      });
    });
    return newState;
  },
  [failedCreateNestedDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedDeleteNestedDecisionBranch]: (state, action) => {
    const { parentId, id } = action.payload;
    const newState = state.concat();
    findDecisionBranchFromTree(newState, parentId, (db) => {
      db.childDecisionBranches = db.childDecisionBranches.filter(cdb => cdb.id !== id);
    });
    return newState;
  },
  [failedDeleteNestedDecisionBranch]: (state, action) => {
    return state;
  },

  [succeedDeleteNestedDecisionBranchAnswer]: (state, action) => {
    const { decisionBranch } = action.payload;
    const newState = state.concat();
    findDecisionBranchFromTree(newState, decisionBranch.id, (db) => {
      db.childDecisionBranches = [];
    });
    return newState;
  },

  [succeedDeleteAnswer]: (state, action) => {
    const { questionAnswer } = action.payload;
    const newState = state.concat();
    newState.forEach((node) => {
      if (node.id === questionAnswer.id) {
        node.decisionBranches = [];
      }
    });
    return newState;
  },
}, initialState);

function findDecisionBranchFromTree(questionsTree, decisionBranchId, foundCallback) {
  const handler = (decisionBranchNodes) => {
    decisionBranchNodes.forEach((decisionBranchNode) => {
      if (decisionBranchNode.id === decisionBranchId) {
        foundCallback(decisionBranchNode);
      } else {
        handler(decisionBranchNode.childDecisionBranches);
      }
    });
  };
  const decisionBranchNodes = flatten(questionsTree.map((n) => n.decisionBranches));
  handler(decisionBranchNodes);
}
