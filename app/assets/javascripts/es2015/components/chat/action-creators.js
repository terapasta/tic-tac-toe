import { createAction } from "redux-actions";
import assign from "lodash/assign";
import trim from "lodash/trim";
import find from "lodash/find";
import findIndex from "lodash/findIndex";
import get from "lodash/get";
import isEmpty from "is-empty";
import toastr from "toastr";
import * as API from "../../api/chat-messages";
import * as MessageRatingAPI from "../../api/chat-message-rating";
import * as ChatTrainigsAPI from "../../api/chat-trainings";
import * as c from "./constants";

import Mixpanel from "../../analytics/mixpanel";
import snakeCaseKeys from "../../modules/snake-case-keys";
export const fetchMessages = createAction("FETCH_MESSAGES", API.fetchMessages);
export const createdMessage = createAction("CREATED_MESSAGE");

export const postMessageIfNeeded = (token, messageBody) => {
  const m = trim(messageBody);
  return (dispatch, getState) => {
    if (isEmpty(m)) { return toastr.warning(c.ErrorPostMessage) }
    if(getState().form.isDisabled) { return; }
    dispatch(disableForm());
    postMessage(token, m, dispatch);
    trackMixpanel("Create chat message");
  };
};

export function postMessage(token, messageBody, dispatch) {
  API.postMessage(token, messageBody)
    .then((res) => {
      dispatch(createdMessage(res));
      dispatch(clearMessageBody());
      dispatch(enableForm());
      dispatch(disableFormIfHasDecisionBranches(res.data));
    })
    .catch((err) => {
      console.error(err);
      toastr.error(c.ErrorCreateMessage, c.ErrorTitle);
    });
}

export const changeMessageBody = createAction("CHANGE_MESSAGE_BODY");
export const clearMessageBody = createAction("CLEAR_MESSAGE_BODY");
export const disableForm = createAction("DISABLE_FORM");
export const enableForm = createAction("ENABLE_FORM");

export function disableFormIfHasDecisionBranches(data) {
  return (dispatch, getState) => {
    const botMessage = find(data.messages, (m) => m.speaker === "bot");
    const decisionBranches = get(botMessage, "answer.decisionBranches");
    if (isEmpty(decisionBranches)) { return; }
    dispatch(disableForm());
  };
}

export function chooseDecisionBranch(token, decisionBranchId) {
  return (dispatch, getState) => {
    API.chooseDecisionBranch(token, decisionBranchId)
      .then((res) => {
        dispatch(chosenDecisionBranch(res));
        dispatch(enableForm());
      })
      .catch((err) => {
        console.error(err);
        toastr.error(c.ErrorCreateMessage, c.ErrorTitle);
      });
  };
}

export const chosenDecisionBranch = createAction("CHOSEN_DECISION_BRANCH");

export function changeMessageRatingTo(type, token, messageId) {
  return (dispatch, getState) => {
    switch (type) {
      case c.Ratings.Good:
        trackMixpanel("Good rating answer", { messageId })
        dispatch(goodMessage(token, messageId));
        break;
      case c.Ratings.Bad:
        trackMixpanel("Bad rating answer", { messageId })
        dispatch(badMessage(token, messageId));
        break;
      case c.Ratings.Nothing:
        trackMixpanel("No rating answer", { messageId })
        dispatch(nothingMessage(token, messageId));
        break;
    }
  };
}

export const goodMessage = createAction("GOOD_MESSAGE", MessageRatingAPI.good);
export const badMessage = createAction("BAD_MESSAGE", MessageRatingAPI.bad);
export const nothingMessage = createAction("NOTHING_MESSAGE", MessageRatingAPI.nothing);

export function trackMixpanel(eventName, options) {
  const { id, name } = window.currentBot;
  const snakeCaseOptions = snakeCaseKeys(options);
  const opt = assign({ bot_id: id, bot_name: name, }, snakeCaseOptions);
  Mixpanel.sharedInstance.trackEvent(eventName, opt);
}

export function toggleActiveSection(index) {
  return (dispatch, getState) => {
    const { messages } = getState();
    const { classifiedData } = messages;
    const hasActive = classifiedData.filter((s) => s.isActive).length > 0;
    const section = classifiedData[index];
    const { question, answer } = section;

    classifiedData.forEach((section, i) => {
      if (i === index) {
        if (section.isActive) {
          dispatch(inactiveSection(i));
        } else {
          dispatch(activeSection(i));
          dispatch(newLearning({
            questionId: question.id,
            answerId: answer.id,
            questionBody: question.body,
          }));
        }
      } else if (hasActive) {
        dispatch(inactiveSection(i));
      } else{
        dispatch(disableSection(i));
      }
    });

    if (hasActive) {
      dispatch(enableForm());
    } else {
      dispatch(disableForm());
    }
  };
}

export const activeSection = createAction("ACTIVE_SECTION");
export const disableSection = createAction("DISABLE_SECTION");
export const inactiveSection = createAction("INACTIVE_SECTION");

export const newLearning = createAction("NEW_LEARNING");
export const updateLearning = createAction("UPDATE_LEARNING");
export const enableLearning = createAction("ENABLE_LEARNING");
export const disableLearning = createAction("DISABLE_LEARNING");

export function saveLearning({ questionId, answerId }) {
  return (dispatch, getState) => {
    const { messages, learnings, token } = getState();
    const { classifiedData } = messages;
    const sectionIndex = findIndex(classifiedData, {
      question: { id: questionId },
      answer: { id: answerId },
    });
    const section = classifiedData[sectionIndex];
    const learningIndex = findIndex(learnings, { questionId, answerId });
    const learning = learnings[learningIndex];
    const { questionBody, answerBody } = learning;

    if (!learning) { return; }
    if (isEmpty(questionBody) || isEmpty(answerBody)) {
      return toastr.warning("質問と新しい回答を入力してください");
    }

    dispatch(disableLearning({ questionId, answerId }));

    ChatTrainigsAPI.create(token, {
      questionBody,
      answerBody,
      questionId,
      answerId,
    }).then((res) => {
      dispatch(updateMessage({ id: questionId, body: questionBody }));
      dispatch(updateMessage({ id: answerId, body: answerBody }));
      dispatch(enableLearning({ questionId, answerId }));
      classifiedData.forEach((_, i) => dispatch(inactiveSection(i)));
      toastr.success(c.SucceededTraining);
    }).catch((err) => {
      console.error(err);
      dispatch(enableLearning({ questionId, answerId }));
    });
  };
}

export const updateMessage = createAction("UPDATE_MESSAGE");
