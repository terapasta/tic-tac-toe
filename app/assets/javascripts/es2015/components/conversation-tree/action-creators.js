import * as t from "./action-types";
import includes from "lodash/includes";

import Answer from "../../models/answer";
import DecisionBranch from "../../models/decision-branch";

export function addAnswerToAnswersTree(answerBody, decisionBranchId = null) {
  return (dispatch, getState) => {
    const { botId, isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    Answer.create(botId, { body: answerBody }).then((answerModel) => {
      dispatch({ type: t.ADD_ANSWER_TO_ANSWERS_TREE, answerModel, decisionBranchId });
      dispatch(addAnswersRepo(answerModel));
      dispatch(offProcessing());
    }).catch(console.error);
  };
}

export function addDecisionBranchToAnswersTree(decisionBranchBody, answerId) {
  return (dispatch, getState) => {
    const { botId, isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    DecisionBranch.create(botId, { body: decisionBranchBody }).then((decisionBranchModel) => {
      dispatch({ type: t.ADD_DECISION_BRANCH_TO_ANSWERS_TREE, decisionBranchModel, answerId });
      dispatch(addDecisionBranchesRepo(decisionBranchModel));
      dispatch(offProcessing());
    }).catch(console.error);
  };
}

export function deleteAnswerFromAnswersTree(answerModel, decisionBranchId) {
  return (dispatch, getState) => {
    const { isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    answerModel.delete().then(() => {
      dispatch({ type: t.DELETE_ANWER_FROM_ANSWERS_TREE, answerModel, decisionBranchId });
      dispatch(deleteAnswersRepo(answerModel));
      dispatch(offProcessing());
    }).catch(console.error);
  };
}

export function deleteDecisionBranchFromAnswersTree(decisionBranchModel, answerId) {
  return { type: t.DELETE_DECISION_BRANCH_FROM_ANSWERS_TREE, decisionBranchModel, answerId };
}

export function updateAnswersRepo(answerModel) {
  return { type: t.UPDATE_ANSWERS_REPO, answerModel };
}

export function deleteAnswersRepo(answerModel) {
  return { type: t.DELETE_ANSWERS_REPO, answerModel };
}

export function addAnswersRepo(answerModel) {
  return { type: t.ADD_ANSWERS_REPO, answerModel };
}

export function updateDecisionBranchesRepo(decisionBranchModel) {
  return { type: t.UPDATE_DECISION_BRANCHES_REPO, decisionBranchModel };
}

export function deleteDecisionBranchesRepo(decisionBranchModel) {
  return { type: t.DELETE_DECISION_BRANCHES_REPO, decisionBranchModel };
}

export function addDecisionBranchesRepo(decisionBranchModel) {
  return { type: t.ADD_DECISION_BRANCHES_REPO, decisionBranchModel };
}

export function addOpenedAnswerIds(answerId) {
  return { type: t.ADD_OPENED_ANSWER_IDS, answerId };
}

export function removeOpenedAnswerIds(answerId) {
  return { type: t.REMOVE_OPENED_ANSWER_IDS, answerId };
}

export function addOpenedDecisionBranchIds(decisionBranchId) {
  return { type: t.ADD_OPENED_DECISION_BRANCH_IDS, decisionBranchId };
}

export function removeOpenedDecisionBranchIds(decisionBranchId) {
  return { type: t.REMOVE_OPENED_DECISION_BRANCH_IDS, decisionBranchId };
}

export function toggleOpenedAnswerIds(answerId) {
  return (dispatch, getState) => {
    const { openedAnswerIds } = getState();
    if (includes(openedAnswerIds, answerId)) {
      dispatch(removeOpenedAnswerIds(answerId));
    } else {
      dispatch(addOpenedAnswerIds(answerId));
    }
  };
}

export function toggleOpenedDecisionBranchIds(decisionBranchId) {
  return (dispatch, getState) => {
    const { openedDecisionBranchIds } = getState();
    if (includes(openedDecisionBranchIds, decisionBranchId)) {
      dispatch(removeOpenedDecisionBranchIds(decisionBranchId));
    } else {
      dispatch(addOpenedDecisionBranchIds(decisionBranchId));
    }
  };
}

export function toggleOpenedIds(dataType, id) {
  return (dispatch) => {
    switch(dataType) {
      case "answer":
        return dispatch(toggleOpenedAnswerIds(id));
      case "decisionBranch":
        return dispatch(toggleOpenedDecisionBranchIds(id));
    }
  };
}

export function onAddingAnswer() {
  return { type: t.ON_ADDING_ANSWER };
}

export function offAddingAnswer() {
  return { type: t.OFF_ADDING_ANSWER };
}

export function onAddingDecisionBranch() {
  return { type: t.ON_ADDING_DECISION_BRANCH };
}

export function offAddingDecisionBranch() {
  return { type: t.OFF_ADDING_DECISION_BRANCH };
}

export function onProcessing() {
  return { type: t.ON_PROCESSING };
}

export function offProcessing() {
  return { type: t.OFF_PROCESSING };
}

export function setActiveItem(dataType, id) {
  return (dispatch, getState) => {
    const { botId } = getState();
    dispatch({ type: t.SET_ACTIVE_ITEM, dataType, id });

    switch(dataType) {
      case "answer":
        if (id == null) {
          return dispatch(setEditingAnswerModel(new Answer));
        } else {
          return Answer.fetch(botId, id).then((answerModel) => {
            dispatch(setEditingAnswerModel(answerModel));
          });
        }
      case "decisionBranch":
        return DecisionBranch.fetch(botId, id).then((decisionBranchModel) => {
          dispatch(setEditingDecisionBranchModels([decisionBranchModel]));
        });
    }
  };
}
}

export function clearActiveItem() {
  return { type: t.CLEAR_ACTIVE_ITEM };
}

export function setEditingAnswerModel(answerModel) {
  return { type: t.SET_EDITING_ANSWER_MODEL, answerModel };
}

export function clearEditingAnswerModel() {
  return { type: t.CLEAR_EDITING_ANSWER_MODEL };
}

export function setEditingDecisionBranchModels(decisionBranchModels) {
  return { type: t.SET_EDITING_DECISION_BRANCH_MODELS, decisionBranchModels };
}

export function clearEditingDecisionBranchModels() {
  return { type: t.CLEAR_EDITING_DECISION_BRANCH_MODELS };
}

export function activateEditingDecisionBranchModel(index) {
  return { type: t.ACTIVATE_EDITING_DECISION_BRANCH_MODEL, index };
}
