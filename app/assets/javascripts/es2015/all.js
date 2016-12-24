import ConversationTree from "./components/conversation-tree";
import ConversationTreeReducers from "./components/conversation-tree/reducers";

import { mountComponentWithRedux } from "./modules/mount-component";

function init() {
  mountComponentWithRedux(ConversationTree, ConversationTreeReducers);
}

if (document.readyState === "complete") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
