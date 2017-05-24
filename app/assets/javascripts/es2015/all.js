import "babel-polyfill";
import promiseMiddleware from 'redux-promise';

import ChatApp from "./components/chat/app";
import ChatAppReducers from "./components/chat/reducers";
import MessageRatingButtons from "./components/message-rating-buttons";
import ConversationTree from "./components/conversation-tree";
import ConversationTreeReducers from "./components/conversation-tree/reducers";
import BotResetButton from "./components/bot-reset-button";
import QuestionAnswerForm from "./components/question-answer-form";
import mountComponent, { mountComponentWithRedux } from "./modules/mount-component";
import Mixpanel from "./analytics/mixpanel";
import LearningButton from "./components/learning-button";
import CopyButton from "./components/copy-button";

window.initMessageRatingButtons = () => {
  MessageRatingButtons.mountComponentAll();
};

function init() {
  Mixpanel.initialize("3c53484fb604d6e20438b4fac8d2ea56");
  window.initMessageRatingButtons();
  mountComponentWithRedux(ChatApp, ChatAppReducers, [promiseMiddleware]);
  mountComponentWithRedux(ConversationTree, ConversationTreeReducers);
  mountComponent(BotResetButton);
  mountComponent(QuestionAnswerForm);
  mountComponent(LearningButton);
  CopyButton.initialize();
}

if (document.readyState === "complete") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
