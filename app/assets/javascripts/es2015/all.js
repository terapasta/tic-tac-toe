import "babel-polyfill";

import ConversationTree from "./components/conversation-tree";
import ConversationTreeReducers from "./components/conversation-tree/reducers";

import BotResetButton from "./components/bot-reset-button";
import MessageRatingButtons from "./components/message-rating-buttons";

import mountComponent, { mountComponentWithRedux } from "./modules/mount-component";

window.initMessageRatingButtons = () => {
  MessageRatingButtons.mountComponentAll();
};

function init() {
  mountComponentWithRedux(ConversationTree, ConversationTreeReducers);
  mountComponent(BotResetButton);
  window.initMessageRatingButtons();
}

if (document.readyState === "complete") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
