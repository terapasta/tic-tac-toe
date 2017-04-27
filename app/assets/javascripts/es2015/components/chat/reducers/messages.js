import assign from "lodash/assign";
import chunk from "lodash/chunk";
import get from "lodash/get";
import cloneDeep from "lodash/cloneDeep";
import last from "lodash/last";
import pick from "lodash/pick";
import findIndex from "lodash/findIndex";
import isEmpty from "is-empty";
import Promise from "promise";
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
    sections.push({ answer: messages.shift() });
  }

  messages.forEach((message) => {
    switch(message.speaker) {
      case Speaker.Guest:
        sections.push({ question: message });
        break;
      case Speaker.Bot:
        sections = classifyBotMessage(sections, message);
        break;
    }
  });

  return sections;
}

export function classifyBotMessage(sections, message) {
  let secs = cloneDeep(sections);
  let lastSec = last(secs);
  lastSec.answer = pickUp(message);
  secs[secs.length - 1] = lastSec;

  const decisionBranches = get(message, "answer.decisionBranches");
  if (!isEmpty(decisionBranches)) {
    secs.push({ decisionBranches });
  }

  const { similarQuestionAnswers } = message;
  if (!isEmpty(similarQuestionAnswers)) {
    secs.push({ similarQuestionAnswers });
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
        }
      });
    });
    return assign({}, state, { classifiedData: data });
  }
}, {
  data: [],
  classifiedData: [],
  meta: {},
});

function pickUp(message) {
  return pick(message, ["id", "body", "createdAt", "rating", "iconImageUrl", "similarQuestionAnswers"]);
}

export function changeRatingHandler(state, action) {
  const { message } = action.payload.data;
  const index = findIndex(state.classifiedData, (section) => {
    return get(section, "answer.id") === message.id;
  });
  const section = state.classifiedData[index];
  const classifiedData =[
    ...state.classifiedData.slice(0, index),
    assign(section, { answer: pickUp(message) }),
    ...state.classifiedData.slice(index + 1),
  ];
  return assign({}, state, { classifiedData });
}

export function doneDecisionBranchesOtherThanLast(classifiedData) {
  const data = cloneDeep(classifiedData);
  return data.map((section, i) => {
    const isExistsDB = !isEmpty(section.decisionBranches);
    const isExistsSQA = !isEmpty(section.similarQuestionAnswers);
    if ((isExistsDB || isExistsSQA) && i !== data.length - 1) {
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
