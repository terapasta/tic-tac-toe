import { createAction } from 'redux-actions';

export const openQuestionNode = createAction('OPEN_QUESTION_NODE');
export const closeQuestionNode = createAction('CLOSE_QUESTION_NODE');
export const toggleQuestionNode = createAction('TOGGLE_QUESTION_NODE');

export const openAnswerNode = createAction('OPEN_ANSWER_NODE');
export const closeAnswerNode = createAction('CLOSE_ANSWER_NODE');
export const toggleAnswerNode = createAction('TOGGLE_ANSWER_NODE');

export const openDecisionBranchNode = createAction('OPEN_DECISION_BRANCH_NODE');
export const closeDecisionBranchNode = createAction('CLOSE_DECISION_BRANCH_NODE');
export const toggleDecisionBranchNode = createAction('TOGGLE_DECISION_BRANCH_NODE');
