import { createAction } from 'redux-actions';

import * as DecisionBranchAPI from '../../../api/decision-branch';

export const succeedCreateDecisionBranch = createAction('SUCCEED_CREATE_DECISION_BRANCH');
export const succeedCreateDecisionBranchForRepo = createAction('SUCCEED_CREATE_DECISION_BRANCH_FOR_REPO');
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
      dispatch(succeedCreateDecisionBranchForRepo(res.data));
    }).catch((res) => {
      dispatch(failedCreateDecisionBranch(res.data));
    });
  }
);
