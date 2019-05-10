import assign from "lodash/assign";
import get from "lodash/get";
import cloneDeep from "lodash/cloneDeep";
import last from "lodash/last";
import pick from "lodash/pick";
import findIndex from "lodash/findIndex";
import isArray from "lodash/isArray";
import times from "lodash/times";
import isEmpty from "is-empty";
import { handleActions } from "redux-actions";

import {
  fetchedMessages,
  createdMessage,
  goodMessage,
  badMessage,
  nothingMessage,
  chosenDecisionBranch,
  activeSection,
  disableSection,
  inactiveSection,
  updateMessage,
  setInitialQuestionsToMessages,
} from "../action-creators";

import {
  Ratings
} from "../constants";

const Speaker = {
  Bot: "bot",
  Guest: "guest",
};

export function classify(data, messages, isLastPage) {
  let sections = cloneDeep(data);
  if (data.length === 0 && isLastPage) {
    sections.push({ answer: messages[0] });
  }

  messages.forEach((message) => {
    const { isShowSimilarQuestionAnswers } = message;
    switch(message.speaker) {
      case Speaker.Guest:
        sections.push({ question: message, isShowSimilarQuestionAnswers });
        break;
      case Speaker.Bot:
        sections = classifyBotMessage(sections, message);
        break;
      default: break;
    }
  });

  return sections;
}

export function classifyBotMessage(sections, message) {
  let secs = cloneDeep(sections);
  let lastSec = last(secs);
  lastSec.answer = pickUp(message);
  secs[secs.length - 1] = lastSec;

  const { similarQuestionAnswers, isShowSimilarQuestionAnswers } = message;
  const decisionBranches = get(message, "questionAnswer.decisionBranches", null) || get(message, 'childDecisionBranches');

  if (!isEmpty(decisionBranches)) {
    secs.push({ decisionBranches, isShowSimilarQuestionAnswers: true });
  }

  if (!isEmpty(similarQuestionAnswers)) {
    secs.push({ similarQuestionAnswers, isShowSimilarQuestionAnswers });
  }

  return secs;
}

export default handleActions({
  [fetchedMessages]: (state, action) => {
    const { isLastPage, data: { messages, meta } } = action.payload;
    let classifiedData = doneDecisionBranchesOtherThanLast(classify([], messages, isLastPage));

    if (meta.currentPage > 1) {
      classifiedData = classifiedData.concat(state.classifiedData);
    }
    return assign({}, state, { classifiedData, meta, isNeedScroll: false });
  },

  [createdMessage]: (state, action) => {
    const { messages } = action.payload.data;
    const classifiedData = doneDecisionBranchesOtherThanLast(classify(state.classifiedData, messages));
    return assign({}, state, { classifiedData, isNeedScroll: true });
  },

  [chosenDecisionBranch]: (state, action) => {
    const { messages } = action.payload.data;
    const classifiedData = doneDecisionBranchesOtherThanLast(classify(state.classifiedData, messages));
    return assign({}, state, { classifiedData });
  },

  [goodMessage]: changeRatingHandler,
  [badMessage]: changeRatingHandler,
  [nothingMessage]: changeRatingHandler,

  [activeSection]: sectionActiveStateHandler((datum) => {
    datum.isActive = true;
    delete datum.isDisabled;
  }),

  [disableSection]: sectionActiveStateHandler((datum) => {
    delete datum.isActive;
    datum.isDisabled = true;
  }),

  [inactiveSection]: sectionActiveStateHandler((datum) => {
    delete datum.isActive;
    delete datum.isDisabled;
  }),

  // TODO replaceMessageに直したい
  [updateMessage]: (state, action) => {
    const { id, body } = action.payload;
    const data = cloneDeep(state.classifiedData);
    data.forEach((section) => {
      ["question", "answer"].forEach((attr) => {
        if (get(section, `${attr}.id`) === id) {
          section[attr].body = body;
          section[attr].rating = Ratings.Nothing;
          section[attr].answerFailed = false;
        }
      });
    });
    return assign({}, state, { classifiedData: data });
  },

  [setInitialQuestionsToMessages]: (state, action) => {
    const data = cloneDeep(state.classifiedData);
    const { payload } = action;
    let initialQuestionsSection = data[1];
    let sliceIndex = 2;

    if (isEmpty(initialQuestionsSection)) {
      initialQuestionsSection = { similarQuestionAnswers: payload };
    } else if (isArray(initialQuestionsSection.similarQuestionAnswers)) {
      initialQuestionsSection.similarQuestionAnswers = payload;
    } else if (isEmpty(initialQuestionsSection.similarQuestionAnswers)) {
      initialQuestionsSection = { similarQuestionAnswers: payload };
      sliceIndex = 1;
    }

    initialQuestionsSection.isShowSimilarQuestionAnswers = true

    return assign({}, state, { classifiedData: [
      data[0],
      initialQuestionsSection,
      ...data.slice(sliceIndex),
    ] });
  },
}, {
  data: [],
  classifiedData: [],
  meta: {},
});

function pickUp(message) {
  let result = pick(message, [
    "id",
    "body",
    "createdAt",
    "rating",
    "iconImageUrl",
    "similarQuestionAnswers",
    "answerFiles",
    "answerFailed",
    "replyLog",
  ]);
  return result;
}

export function changeRatingHandler(state, action) {
  const { message } = action.payload.data;
  const index = findIndex(state.classifiedData, (section) => {
    return get(section, "answer.id") === message.id;
  });
  const section = state.classifiedData[index];
  const tailSections = state.classifiedData.slice(index + 1);

  if (message.rating === Ratings.Bad) {
    times(2, (n) => {
      if (!isEmpty((tailSections[n] || {}).similarQuestionAnswers)) {
        tailSections[n] = assign({}, tailSections[n], { isShowSimilarQuestionAnswers: true });
      }
    })
  }

  const classifiedData =[
    ...state.classifiedData.slice(0, index),
    assign(section, { answer: pickUp(message) }),
    ...tailSections
  ];
  return assign({}, state, { classifiedData });
}

const isSkipDoneDB = true;

export function doneDecisionBranchesOtherThanLast(classifiedData) {
  if (isSkipDoneDB) {
    return classifiedData;
  }
  const data = cloneDeep(classifiedData);
  const beforeLastIndex = data.length - 2;
  const lastIndex = data.length - 1;
  const beforeLastSection = data[beforeLastIndex];
  const lastSection = data[lastIndex];

  const hasDBorSQL = (section) => {
    const isExistsDB = !isEmpty(section.decisionBranches);
    const isExistsSQA = !isEmpty(section.similarQuestionAnswers);
    return isExistsDB || isExistsSQA;
  };

  return data.map((section, i) => {
    const isLast = i === lastIndex;
    const isBeforeLast = i === beforeLastIndex;

    if (hasDBorSQL(section) && !isLast) {
      // 最後から２つのsectionが両方共選択系だったらdoneしない
      if (hasDBorSQL(beforeLastSection) &&
          hasDBorSQL(lastSection) &&
          isBeforeLast) { return section; }
      section.isDone = true;
    }
    return section;
  });
}

export function sectionActiveStateHandler(manipulator) {
  return (state, action) => {
    const data = cloneDeep(state.classifiedData);
    const datum = data[action.payload];
    manipulator(datum);
    return assign({}, state, { classifiedData: data });
  }
}
