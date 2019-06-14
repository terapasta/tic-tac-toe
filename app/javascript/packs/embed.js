import '../embed/array-reduce-polyfill'
import ES6Promise from "es6-promise";
import { directMountComponent } from "../helpers/mountComponent";

import {
  Namespace
} from "../embed/constants";


import Widget from "../embed/widget";

ES6Promise.polyfill();

function init() {
  const mountNode = document.querySelector("#" + Namespace);
  const widget = directMountComponent(Widget, mountNode);
  window.__myopeWidget_moveToRight = () => widget.moveToRight()
  window.__myopeWidget_moveToLeft = () => widget.moveToLeft()
}

if (document.readyState === "complete" ||
    document.readyState === "interactive") {
  init();
} else {
  document.addEventListener("DOMContentLoaded", init);
}
