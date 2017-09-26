import { directMountComponent } from "./modules/mount-component";

import {
  Namespace
} from "./embed/constants";

import Widget from "./embed/widget";

// if (!window._babelPolyfill) {
//   require("babel-polyfill");
// }

function init() {
  const mountNode = document.querySelector("#" + Namespace);
  directMountComponent(Widget, mountNode);
}

if (document.readyState === "complete" ||
    document.readyState === "interactive") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
