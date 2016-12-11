import ConversationTree from "./components/conversation-tree";

import mountComponent from "./modules/mount-component";

function init() {
  mountComponent(ConversationTree);
}

if (document.readyState === "complete") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
