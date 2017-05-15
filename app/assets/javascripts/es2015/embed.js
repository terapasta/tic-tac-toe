import React from "react";
import { render } from "react-dom";

import { directMountComponent } from "./modules/mount-component";

import {
  Namespace
} from "./embed/constants";

import Widget from "./embed/widget";

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
