import * as t from "./action-types";
import includes from "lodash/includes";
import get from "lodash/get";
import find from "lodash/find";

import Question from "../../models/question";
import Answer from "../../models/answer";
import DecisionBranch from "../../models/decision-branch";

import {
  findAnswerFromTree,
  findDecisionBranchFromTree,
  findQuestionFromTree
} from "./helpers";

export function addAnswerToAnswersTree(answerBody, options = {}) {
  const { decisionBranchId, questionModel } = options;

  return (dispatch, getState) => {
    const { botId, isProcessing, editingDecisionBranchModel, editingQuestionModel, questionsTree } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    Answer.create(botId, { body: answerBody }).then((answerModel) => {
      dispatch(offProcessing());
      dispatch(addAnswersRepo(answerModel));
      dispatch({ type: t.ADD_ANSWER_TO_ANSWERS_TREE, answerModel, decisionBranchId });

      if (decisionBranchId != null) {
        dispatch(updateDecisionBranchModel(editingDecisionBranchModel, { nextAnswerId: answerModel.id }));

        findDecisionBranchFromTree(questionsTree, decisionBranchId, (decisionBranchNode) => {
          decisionBranchNode.answer = {
            id: answerModel.id,
            decisionBranches: [],
          }
        });
        dispatch(addOpenedDecisionBranchIds(decisionBranchId));
      }

      if (questionModel != null) {
        dispatch(updateQuestionModel(questionModel, { answerId: answerModel.id }, { isNeedSetEditingQuestionModel: false }));
        dispatch(updateQuestionAnswerInQuestionsTree(questionModel, { id: answerModel.id }));
        dispatch(addOpenedQuestionIds(questionModel.id));
      }

      dispatch(setEditingAnswerModel(answerModel));
      dispatch(addOpenedAnswerIdsIfHasChildren(answerModel.id));
      dispatch(setActiveItem("answer", answerModel.id));

    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
}

export function addQuestionToQuestionsTree(question, options = {}) {
  return (dispatch, getState) => {
    const { botId, isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    const { answerModel, answerBody } = options;

    Question.create(botId, { question }).then((questionModel) => {
      dispatch(addQuestionsRepo(questionModel));
      dispatch({ type: t.ADD_QUESTION_TO_QUESTIONS_TREE, questionModel });
      dispatch(setEditingQuestionModel(questionModel));
      dispatch(setActiveItem("question", questionModel.id));
      dispatch(offProcessing());

      if (answerModel != null && answerBody != null) {
        if (get(answerModel, "id") == null) {
          dispatch(addAnswerToAnswersTree(answerBody, {
            questionModel,
          }));
        } else {
          dispatch(updateAnswerModel(answerModel, { body: answerBody }));
        }
      }
    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
}

export function updateQuestionAnswerInQuestionsTree(questionModel, answerNode) {
  return { type: t.UPDATE_QUESTION_ANSWER_IN_QUESTIONS_TREE, questionModel, answerNode };

}

export function addDecisionBranchToQuestionsTree(decisionBranchBody, answerId) {
  return (dispatch, getState) => {
    const { botId, isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    DecisionBranch.create(botId, { body: decisionBranchBody, answer_id: answerId }).then((decisionBranchModel) => {
      dispatch(addDecisionBranchesRepo(decisionBranchModel));
      dispatch({ type: t.ADD_DECISION_BRANCH_TO_QUESTIONS_TREE, decisionBranchModel, answerId });
      dispatch(addEditingDecisionBranchModels(decisionBranchModel));
      dispatch(offProcessing());
      dispatch(offAddingDecisionBranch());
    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
}

export function deleteQuestionFromQuestionsTree(questionModel) {
  return (dispatch, getState) => {
    const { isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    questionModel.delete().then(() => {
      dispatch({ type: t.DELETE_QUESTION_FROM_QUESTIONS_TREE, questionModel });
      dispatch(deleteQuestionsRepo(questionModel));
      dispatch(clearEditingQuestionModel());
      dispatch(clearActiveItem());
      dispatch(offProcessing());
    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
}

export function deleteAnswerFromAnswersTree(answerModel, decisionBranchId) {
  return (dispatch, getState) => {
    const { isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    answerModel.delete().then(() => {
      dispatch({ type: t.DELETE_ANSWER_FROM_QUESTIONS_TREE, answerModel, decisionBranchId });
      dispatch(deleteAnswersRepo(answerModel));
      dispatch(clearEditingAnswerModel());
      dispatch(clearEditingDecisionBranchModels());
      dispatch(clearActiveItem());
      dispatch(offProcessing());
    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
}

export function deleteDecisionBranchFromQuestionsTree(decisionBranchModel, answerId) {
  return (dispatch, getState) => {
    const { isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    decisionBranchModel.delete().then(() => {
      dispatch({ type: t.DELETE_DECISION_BRANCH_FROM_QUESTIONS_TREE, decisionBranchModel });
      dispatch(deleteDecisionBranchesRepo(decisionBranchModel));
      dispatch(deleteEditingDecisionBranchModels(decisionBranchModel));
      dispatch(offProcessing());
    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
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

export function updateQuestionsRepo(questionModel) {
  return { type: t.UPDATE_QUESTIONS_REPO, questionModel };
}

export function deleteQuestionsRepo(questionModel) {
  return { type: t.DELETE_QUESTIONS_REPO, questionModel };
}

export function addQuestionsRepo(questionModel) {
  return { type: t.ADD_QUESTIONS_REPO, questionModel };
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

export function addOpenedQuestionIds(questionId) {
  return { type: t.ADD_OPENED_QUESTION_IDS, questionId };
}

export function removeOpenedQuestionIds(questionId) {
  return { type: t.REMOVE_OPENED_QUESTION_IDS, questionId };
}

export function addOpenedAnswerIds(answerId) {
  return { type: t.ADD_OPENED_ANSWER_IDS, answerId };
}

export function removeOpenedAnswerIds(answerId) {
  return { type: t.REMOVE_OPENED_ANSWER_IDS, answerId };
}

export function addOpenedAnswerIdsIfHasChildren(answerId) {
  return (dispatch, getState) => {
    const { answersTree } = getState();
    findAnswerFromTree(answersTree, answerId, (answerNode) => {
      if (answerNode.decisionBranches.length > 0) {
        dispatch(addOpenedAnswerIds(answerId));
      }
    });
  };
}

export function addOpenedDecisionBranchIds(decisionBranchId) {
  return { type: t.ADD_OPENED_DECISION_BRANCH_IDS, decisionBranchId };
}

export function removeOpenedDecisionBranchIds(decisionBranchId) {
  return { type: t.REMOVE_OPENED_DECISION_BRANCH_IDS, decisionBranchId };
}

export function toggleOpenedQuestionIds(questionId) {
  return (dispatch, getState) => {
    const { openedQuestionIds } = getState();
    if (includes(openedQuestionIds, questionId)) {
      dispatch(removeOpenedQuestionIds(questionId));
    } else {
      dispatch(addOpenedQuestionIds(questionId));
    }
  };
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
      case "question":
        return dispatch(toggleOpenedQuestionIds(id))
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
  window.scrollTo(0, 0);
  return (dispatch, getState) => {
    const { botId, questionsTree, questionsRepo, decisionBranchesRepo } = getState();
    dispatch({ type: t.SET_ACTIVE_ITEM, dataType, id });
    dispatch(clearEditingQuestionModel());
    dispatch(clearEditingAnswerModel());
    dispatch(clearEditingDecisionBranchModel());
    dispatch(clearEditingDecisionBranchModels());

    switch(dataType) {
      case "question":
        if (id == null) {
          return dispatch(setEditingQuestionModel(new Question));
        } else {
          const questionData = questionsRepo[id];
          const question = get(questionData, "question");
          const answer = get(questionData, "answer");
          dispatch(setEditingQuestionModel(new Question({ question })));
          dispatch(setEditingAnswerModel(new Answer({ body: answer })));

          // return Question.fetch(botId, id).then((questionModel) => {
          //   if (getState().activeItem.dataType !== "question") { return; }
          //   dispatch(setEditingQuestionModel(questionModel));
          // });
        }
      case "answer":
        if (id == null) {
          return dispatch(setEditingAnswerModel(new Answer));
        } else {
          const answer = get(questionsRepo[id], "answer");
          dispatch(setEditingAnswerModel(new Answer({ body: answer })));

          const questionNode = find(questionsTree, (q) => q.id == id);
          const decisionBranchModels = questionNode.decisionBranches.map((dbNode) => {
            const db = decisionBranchesRepo[dbNode.id];
            return new DecisionBranch(db);
          });
          dispatch(setEditingDecisionBranchModels(decisionBranchModels));
          break;

          // return Answer.fetch(botId, id).then((answerModel) => {
          //   if (getState().activeItem.dataType !== "answer") { return; }
          //   dispatch(setEditingAnswerModel(answerModel));
          //   answerModel.fetchDecisionBranches().then(() => {
          //     dispatch(setEditingDecisionBranchModels(answerModel.decisionBranchModels));
          //   });
          //   answerModel.fetchQuestions().then(() => {
          //     dispatch(setReferenceQuestionModels(answerModel.questions));
          //   });
          // });
        }
      case "decisionBranch":
        if (id == null) {
          return dispatch(setEditingDecisionBranchModel(new DecisionBranch));
        } else {
          return fetchDecisionBranchModel(dispatch, botId, id);
        }
    }
  };
}

export function fetchDecisionBranchModel(dispatch, botId, id) {
  return DecisionBranch.fetch(botId, id).then((decisionBranchModel) => {
    dispatch(setEditingDecisionBranchModel(decisionBranchModel));

    if (decisionBranchModel.nextAnswerId == null) {
      dispatch(setEditingAnswerModel(new Answer));
    } else {
      decisionBranchModel.fetchNextAnswer().then(() => {
        dispatch(setEditingAnswerModel(decisionBranchModel.nextAnswerModel));
      }).catch((err) => {
        if (err.response.status === 404) {
          dispatch(setEditingAnswerModel(new Answer));
        }
      });
    }
  });
}

export function updateQuestionModel(questionModel, newAttrs, options = {}) {
  return (dispatch, getState) => {
    const { isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    const { answerModel, answerBody, isNeedSetEditingQuestionModel } = options;

    questionModel.update(newAttrs).then((newQuestionModel) => {
      if (isNeedSetEditingQuestionModel == null || isNeedSetEditingQuestionModel) {
        dispatch(setEditingQuestionModel(newQuestionModel));
      }
      dispatch(updateQuestionsRepo(newQuestionModel));
      dispatch(offProcessing());
      if (answerModel != null) {
        if (answerModel.id == null) {
          dispatch(addAnswerToAnswersTree(answerBody, {
            questionModel: newQuestionModel,
          }));
        } else {
          dispatch(updateAnswerModel(answerModel, { body: answerBody }, { questionModel: newQuestionModel }));
        }
      }
    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
}

export function updateAnswerModel(answerModel, newAttrs, options = {}) {
  return (dispatch, getState) => {
    const { isProcessing, questionsTree } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    const { questionModel } = options;

    answerModel.update(newAttrs).then((newAnswerModel) => {
      findAnswerFromTree(questionsTree, answerModel.id, (node) => {
        node.id = newAnswerModel.id;
      });
      dispatch(setEditingAnswerModel(newAnswerModel));
      dispatch(updateAnswersRepo(newAnswerModel));
      dispatch(offProcessing());

      if (questionModel != null) {
        dispatch(updateQuestionModel(questionModel, { answerId: newAnswerModel.id }));
      }
    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
}

export function updateDecisionBranchModel(decisionBranchModel, newAttrs) {
  return (dispatch, getState) => {
    const { isProcessing } = getState();
    if (isProcessing) { return; }
    dispatch(onProcessing());

    decisionBranchModel.update(newAttrs).then((newDecisionBranchModel) => {
      dispatch(updateDecisionBranchesRepo(newDecisionBranchModel));
      dispatch(updateEditingDecisionBranchModels(newDecisionBranchModel));
      dispatch(inactivateEditingDecisionBranchModels());
      dispatch(offProcessing());
    }).catch((err) => {
      dispatch(offProcessing());
      console.error(err);
    });
  };
}

export function clearActiveItem() {
  return { type: t.CLEAR_ACTIVE_ITEM };
}

export function setEditingQuestionModel(questionModel) {
  return (dispatch, getState) => {
    dispatch({ type: t.SET_EDITING_QUESTION_MODEL, questionModel });

    let answer;
    if (questionModel.answerId != null) {
      const { answersRepo } = getState();
      answer = answersRepo[questionModel.answerId];
    }
    const answerModel = new Answer(answer || {});
    dispatch(setEditingAnswerModel(answerModel));
  };
}

export function clearEditingQuestionModel() {
  return { type: t.CLEAR_EDITING_QUESTION_MODEL };
}

export function setEditingAnswerModel(answerModel) {
  return { type: t.SET_EDITING_ANSWER_MODEL, answerModel };
}

export function clearEditingAnswerModel() {
  return { type: t.CLEAR_EDITING_ANSWER_MODEL };
}

export function setEditingDecisionBranchModel(decisionBranchModel) {
  return { type: t.SET_EDITING_DECISION_BRANCH_MODEL, decisionBranchModel };
}

export function clearEditingDecisionBranchModel() {
  return { type: t.CLEAR_EDITING_DECISION_BRANCH_MODEL };
}

export function setEditingDecisionBranchModels(decisionBranchModels) {
  return { type: t.SET_EDITING_DECISION_BRANCH_MODELS, decisionBranchModels };
}

export function addEditingDecisionBranchModels(decisionBranchModel) {
  return { type: t.ADD_EDITING_DECISION_BRANCH_MODELS, decisionBranchModel };
}

export function updateEditingDecisionBranchModels(decisionBranchModel) {
  return { type: t.UPDATE_EDITING_DECISION_BRANCH_MODELS, decisionBranchModel };
}

export function deleteEditingDecisionBranchModels(decisionBranchModel) {
  return { type: t.DELETE_EDITING_DECISION_BRANCH_MODELS, decisionBranchModel };
}

export function clearEditingDecisionBranchModels() {
  return { type: t.CLEAR_EDITING_DECISION_BRANCH_MODELS };
}

export function activateEditingDecisionBranchModel(index) {
  return { type: t.ACTIVATE_EDITING_DECISION_BRANCH_MODEL, index };
}

export function inactivateEditingDecisionBranchModels() {
  return { type: t.INACTIVATE_EDITING_DECISION_BRANCH_MODELS };
}

export function setReferenceQuestionModels(questionModels) {
  return { type: t.SET_REFERENCE_QUESTION_MODELS, questionModels };
}
export function clearReferenceQuestionModels() {
  return { type: t.CLEAR_REFERENCE_QUESTION_MODELS };
}