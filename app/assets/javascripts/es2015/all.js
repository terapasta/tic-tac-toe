import "babel-polyfill";

import ConversationTree from "./components/conversation-tree";
import ConversationTreeReducers from "./components/conversation-tree/reducers";
import BotResetButton from "./components/bot-reset-button";
import MessageRatingButtons from "./components/message-rating-buttons";
import QuestionAnswerForm from "./components/question-answer-form";
import mountComponent, { mountComponentWithRedux } from "./modules/mount-component";
import Mixpanel from "./analytics/mixpanel";

window.initMessageRatingButtons = () => {
  MessageRatingButtons.mountComponentAll();
};

function init() {
  mountComponentWithRedux(ConversationTree, ConversationTreeReducers);
  mountComponent(BotResetButton);
  mountComponent(QuestionAnswerForm);
  window.initMessageRatingButtons();
  Mixpanel.initialize("3c53484fb604d6e20438b4fac8d2ea56");
}

if (document.readyState === "complete") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
