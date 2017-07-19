import { createAction } from 'redux-actions';

import * as DecisionBranchAPI from '../../../api/decision-branch';

export const succeedCreateDecisionBranch = createAction('SUCCEED_CREATE_DECISION_BRANCH');
export const failedCreateDecisionBranch = createAction('FAILED_CREATE_DECISION_BRANCH');

export const succeedUpdateDecisionBranch = createAction('SUCCEED_UPDATE_DECISION_BRANCH');
export const failedUpdateDecisionBranch = createAction('FAILED_UPDATE_DECISION_BRANCH');

export const succeedDeleteDecisionBranch = createAction('SUCCEED_DELETE_DECISION_BRANCH');
export const failedDeleteDecisionBranch = createAction('FAILED_DELETE_DECISION_BRANCH');

export const createDecisionBranch = (answerId, body) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return DecisionBranchAPI.create(botId, answerId, body).then((res) => {
      dispatch(succeedCreateDecisionBranch(res.data));
    }).catch((res) => {
      dispatch(failedCreateDecisionBranch(res.data));
    });
  }
);

export const updateDecisionBranch = (answerId, id, body, answer = null) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return DecisionBranchAPI.update(botId, answerId, id, body, answer).then((res) => {
      dispatch(succeedUpdateDecisionBranch(res.data));
    }).catch((res) => {
      dispatch(failedUpdateDecisionBranch(res.data));
    });
  }
);

export const deleteDecisionBranch = (answerId, id) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return DecisionBranchAPI.destroy(botId, answerId, id).then((res) => {
      dispatch(succeedDeleteDecisionBranch({ questionId: answerId, id }));
    }).catch((res) => {
      dispatch(failedDeleteDecisionBranch(res.data));
    });
  }
);

export const succeedCreateNestedDecisionBranch = createAction('SUCCEED_CREATE_NESTED_DECISION_BRANCH');
export const failedCreateNestedDecisionBranch = createAction('FAILED_CREATE_NESTED_DECISION_BRANCH');

export const succeedUpdateNestedDecisionBranch = createAction('SUCCEED_UPDATE_NESTED_DECISION_BRANCH');
export const failedUpdateNestedDecisionBranch = createAction('FAILED_UPDATE_NESTED_DECISION_BRANCH');

export const succeedDeleteNestedDecisionBranch = createAction('SUCCEED_DELETE_NESTED_DECISION_BRANCH');
export const failedDeleteNestedDecisionBranch = createAction('FAILED_DELETE_NESTED_DECISION_BRANCH');

export const createNestedDecisionBracnh = (parentId, body) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return DecisionBranchAPI.nestedCreate(botId, parentId, body).then((res) => {
      dispatch(succeedCreateNestedDecisionBranch(res.data));
    }).catch((res) => {
      dispatch(failedCreateNestedDecisionBranch(res.data));
    });
  }
);

export const updateNestedDecisionBranch = (id, body, answer = null) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return DecisionBranchAPI.nestedUpdate(botId, id, body, answer).then((res) => {
      dispatch(succeedUpdateNestedDecisionBranch(res.data));
    }).catch((res) => {
      dispatch(failedUpdateNestedDecisionBranch(res.data));
    });
  }
);

export const deleteNestedDecisionBranch = (parentId, id) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return DecisionBranchAPI.nestedDelete(botId, id).then((res) => {
      dispatch(succeedDeleteNestedDecisionBranch({ parentId, id }));
    }).catch((res) => {
      dispatch(failedDeleteNestedDecisionBranch(res.data));
    });
  }
);
