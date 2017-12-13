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
import * as BotLearningAPI from "../../api/bot-learning";
import * as InitialQuestionsAPI from "../../api/initial-questions";
import * as c from "./constants";

import Mixpanel from "../../analytics/mixpanel";
import snakeCaseKeys from "../../modules/snake-case-keys";

const PollingInterval = 1000 * 1;

export const fetchedMessages = createAction("FETCHED_MESSAGES");
export const createdMessage = createAction("CREATED_MESSAGE");

export function fetchMessages(token, page = 1) {
  return (dispatch, getState) => {
    dispatch(disableReadMore());
    API.fetchMessages(token, page).then((res) => {
      const { currentPage, totalPages } = get(res, "data.meta");
      const isApperedReadMore = currentPage < totalPages;
      const isLastPage = !isApperedReadMore;
      dispatch(enableReadMore());
      dispatch(fetchedMessages(assign(res, { isLastPage })));
      dispatch(isApperedReadMore ? appearReadMore() : disappearReadMore());
    }).catch((err) => {
      console.error(err);
    });
  };
}

export function fetchNextMessages() {
  return (dispatch, getState) => {
    const { token, messages: { meta: { currentPage } } } = getState();
    const nextPage = currentPage + 1;
    dispatch(fetchMessages(token, nextPage));
  };
}

export const postMessageIfNeeded = (token, messageBody, options = { isForce: false }) => {
  const m = trim(messageBody);
  return (dispatch, getState) => {
    const process = () => {
      dispatch(disableForm());
      postMessage(token, m, dispatch);
      trackMixpanel("question");
    };
    if (options.isForce) { process(); }
    if (isEmpty(m)) { return toastr.warning(c.ErrorPostMessage) }
    if(getState().form.isDisabled) { return; }
    process();
  };
};

export function postMessage(token, messageBody, dispatch) {
  API.postMessage(token, messageBody)
    .then((res) => {
      dispatch(createdMessage(res));
      dispatch(clearMessageBody());
      dispatch(enableForm());
      dispatch(disableFormIfHasDecisionBranches(res.data));
      dispatch(disableFormIfHasSimilerQuestoinAnswers(res.data));
    })
    .catch((err) => {
      console.error(err);
      if (err.response['status'] === 503) {
        toastr.warning(c.BotIsNotTrainedErrorMessage, c.BotIsNotTrainedErrorTitle);
        return;
      }
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
        trackMixpanel('click choice question');
      })
      .catch((err) => {
        console.error(err);
        toastr.error(c.ErrorCreateMessage, c.ErrorTitle);
      });
  };
}

export const chosenDecisionBranch = createAction("CHOSEN_DECISION_BRANCH");

export function disableFormIfHasSimilerQuestoinAnswers(data) {
  return (dispatch, getState) => {
    const botMessage = find(data.messages, (m) => m.speaker === "bot");
    const similarQuestionAnswers = find(botMessage, "similarQuestionAnswers");
    if (isEmpty(similarQuestionAnswers)) { return; }
    dispatch(disableForm());
  };
}

export function changeMessageRatingTo(type, token, messageId) {
  return (dispatch, getState) => {
    switch (type) {
      case c.Ratings.Good:
        trackMixpanel("good", { messageId })
        dispatch(goodMessage(token, messageId));
        break;
      case c.Ratings.Bad:
        trackMixpanel("bad", { messageId })
        dispatch(badMessage(token, messageId));
        break;
      case c.Ratings.Nothing:
        trackMixpanel("nothing", { messageId })
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
          trackMixpanel('teach from chat screen');
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
      dispatch(enableForm());
      classifiedData.forEach((_, i) => dispatch(inactiveSection(i)));
      toastr.success(c.SucceededTraining);
    }).catch((err) => {
      console.error(err);
      dispatch(enableLearning({ questionId, answerId }));
    });
  };
}

export const updateMessage = createAction("UPDATE_MESSAGE");

export const appearReadMore = createAction("APPEAR_READ_MORE");
export const disappearReadMore = createAction("DISAPPEAR_READ_MORE");
export const enableReadMore = createAction("ENABLE_READ_MORE");
export const disableReadMore = createAction("DISABLE_READ_MORE");

export function startLearningIfPossible(botId) {
  return (dispatch, getState) => {
    const { learning: { status } } = getState();
    if (status !== c.LearningStatus.Processing) {
      dispatch(startLearning(botId));
    }
  };
}

export function pollLearningStatus(botId) {
  return (dispatch, getState) => {
    const { isManager } = getState();
    if (!isManager) { return; }
    dispatch(getLearningStatus(botId));
    setInterval(() => {
      dispatch(getLearningStatus(botId));
    }, PollingInterval);
  };
}

export const startLearning = createAction("START_LEARNING", BotLearningAPI.start);
export const getLearningStatus = createAction("GET_LEARNING_STATUS", BotLearningAPI.status);

export const fetchInitialQuestions = createAction("FETCH_INITIAL_QUESTIONS", InitialQuestionsAPI.fetchAll);
export const setInitialQuestionsToMessages = createAction("SET_INITIAL_QUESTIONS_TO_MESSAGES");
