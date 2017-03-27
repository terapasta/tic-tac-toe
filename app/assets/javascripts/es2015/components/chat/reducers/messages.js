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
  fetchMessages,
  createdMessage,
  goodMessage,
  badMessage,
  nothingMessage,
} from "../action-creators";

const Speaker = {
  Bot: "bot",
  Guest: "guest",
};

export function classify(data, messages) {
  let sections = cloneDeep(data);
  if (data.length === 0) {
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
  return secs;
}

export default handleActions({
  [fetchMessages]: (state, action) => {
    const { payload } = action;

    if (action.error) {
      console.error(payload);
      return state;
    }

    const { messages, meta } = payload.data;
    const data = state.data.concat(messages);
    const classifiedData = classify(state.classifiedData, messages);
    return assign({}, state, { data, classifiedData, meta });
  },

  [createdMessage]: (state, action) => {
    const { messages } = action.payload.data;
    const classifiedData = classify(state.classifiedData, messages);
    return assign({}, state, { classifiedData });
  },

  [goodMessage]: changeRatingHandler,
  [badMessage]: changeRatingHandler,
  [nothingMessage]: changeRatingHandler,
}, {
  data: [],
  classifiedData: [],
  meta: {},
});

function pickUp(message) {
  return pick(message, ["id", "body", "createdAt", "rating", "iconImageUrl"]);
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
