import React, { createElement } from "react";
import { render } from "react-dom";
import camelCase from "lodash/camelCase";

import parseJSON from "./parse-json";

export default function mountComponent(component) {
  const selector = `[data-component="${component.componentName}"]`;
  const mountNodes = [].slice.call(document.querySelectorAll(selector));

  mountNodes.forEach((mountNode) => {
    let props = {};

    [].forEach.call(mountNode.attributes, (attr) => {
      const { name, value } = attr;
      if (/^data\-(?!component)/.test(name)) {
        const propName = camelCase(name.replace(/^data\-/, ""));
        props[propName] = parseJSON(value);
      }
    });

    render(createElement(component, props), mountNode);
  });
}
