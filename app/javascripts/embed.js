import './embed/array-reduce-polyfill'
import ES6Promise from "es6-promise";
import { directMountComponent } from "./modules/mount-component";

import {
  Namespace
} from "./embed/constants";


import Widget from "./embed/widget";

ES6Promise.polyfill();

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
