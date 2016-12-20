import * as t from "./action-types";

export function addAnswerToAnswersTree(answerModel, decisionBranchId) {
  return { type: t.ADD_ANSWER_TO_ANSWERS_TREE, answerModel, decisionBranchId };
}

export function addDecisionBranchToAnswersTree(decisionBranchModel, answerId) {
  return { type: t.ADD_DECISION_BRANCH_TO_ANSWERS_TREE, decisionBranchModel, answerId };
}

export function deleteAnswerFromAnswersTree(answerModel, decisionBranchId) {
  return { type: t.DELETE_ANSWERS_TREE, answerModel, decisionBranchId };
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

export function addOpenedDecisionBranchIds(decisionBranchId) {
  return { type: t.ADD_OPENED_DECISION_BRANCH_IDS, decisionBranchId };
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
  return { type: t.SET_ACTIVE_ITEM, dataType, id };
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
