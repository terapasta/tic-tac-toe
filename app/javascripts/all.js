import "babel-polyfill";
import promiseMiddleware from 'redux-promise';

import ChatApp from "./components/chat/app";
import ChatAppReducers from "./components/chat/reducers";
import MessageRatingButtons from "./components/message-rating-buttons";
import ConversationTree from "./components/conversation-tree-app/app";
import ConversationTreeReducers from "./components/conversation-tree-app/reducers";
import BotResetForm from "./components/bot-reset-form";
import mountComponent, { mountComponentWithRedux } from "./modules/mount-component";
import Mixpanel from "./analytics/mixpanel";
import LearningButton from "./components/learning-button";
import CopyButton from "./components/copy-button";
import QuestionAnswerTagForm from "./components/question-answer-tag-form";
import AnswerTextArea from "./components/answer-text-area";
import EmbedCodeGenerator from "./components/embed-code-generator";
import WordMappings from './components/WordMappings';

window.initMessageRatingButtons = () => {
  MessageRatingButtons.mountComponentAll();
};

function init() {
  Mixpanel.initialize("3c53484fb604d6e20438b4fac8d2ea56");
  Mixpanel.listenEvents();

  window.initMessageRatingButtons();
  mountComponentWithRedux(ChatApp, ChatAppReducers, [promiseMiddleware]);
  mountComponentWithRedux(ConversationTree, ConversationTreeReducers);
  mountComponent(BotResetForm);
  mountComponent(LearningButton);
  mountComponent(QuestionAnswerTagForm);
  mountComponent(AnswerTextArea);
  mountComponent(EmbedCodeGenerator);
  mountComponent(WordMappings);
  CopyButton.initialize();
}

if (document.readyState === "complete") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
