import Tree from "./components/tree";

import mountComponent from "./modules/mount-component";

function init() {
  mountComponent(Tree);
}

if (document.readyState === "complete") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
