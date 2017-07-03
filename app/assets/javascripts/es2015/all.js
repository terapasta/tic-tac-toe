import "babel-polyfill";
import promiseMiddleware from 'redux-promise';

import ChatApp from "./components/chat/app";
import ChatAppReducers from "./components/chat/reducers";
import MessageRatingButtons from "./components/message-rating-buttons";
import ConversationTree from "./components/conversation-tree";
import ConversationTreeReducers from "./components/conversation-tree/reducers";
import BotResetButton from "./components/bot-reset-button";
import mountComponent, { mountComponentWithRedux } from "./modules/mount-component";
import Mixpanel from "./analytics/mixpanel";
import LearningButton from "./components/learning-button";
import CopyButton from "./components/copy-button";
<<<<<<< 5bc4bcedf9f288ed6444b83788f289f7b433f51f
<<<<<<< dbc3fa1b0e9a9af1b50fab6126bf7cab1c4fd4cb
import QuestionAnswerTagForm from "./components/question-answer-tag-form";
import AnswerBodyTextArea from "./components/answer-body-text-area";
=======
import DownloadTableDataButton from "./components/download-table-data-button";
>>>>>>> Implement DownloadTableDataButton component
=======
>>>>>>> Delete DownloadTableDataButton component

window.initMessageRatingButtons = () => {
  MessageRatingButtons.mountComponentAll();
};

function init() {
  Mixpanel.initialize("3c53484fb604d6e20438b4fac8d2ea56");
  window.initMessageRatingButtons();
  mountComponentWithRedux(ChatApp, ChatAppReducers, [promiseMiddleware]);
  mountComponentWithRedux(ConversationTree, ConversationTreeReducers);
  mountComponent(BotResetButton);
  mountComponent(LearningButton);
<<<<<<< 5bc4bcedf9f288ed6444b83788f289f7b433f51f
<<<<<<< dbc3fa1b0e9a9af1b50fab6126bf7cab1c4fd4cb
  mountComponent(QuestionAnswerTagForm);
  mountComponent(AnswerBodyTextArea);
=======
  mountComponent(DownloadTableDataButton);
>>>>>>> Implement DownloadTableDataButton component
=======
>>>>>>> Delete DownloadTableDataButton component
  CopyButton.initialize();
}

if (document.readyState === "complete") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
