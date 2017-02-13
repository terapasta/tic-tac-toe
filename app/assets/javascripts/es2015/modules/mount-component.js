import React, { createElement } from "react";
import { render } from "react-dom";
import { Provider, connect } from "react-redux";
import { createStore, applyMiddleware } from "redux";
import thunk from "redux-thunk";
import createLogger from "redux-logger";

import getData from "./get-data";

/**
 * this function expect like below component
 *
 * class Sample extends React.Component {
 *   static get componentName() {
 *     return "Sample";
 *   }
 * }
 */
export default function mountComponent(component) {
  const mountNodes = getMountNodes(component);

  mountNodes.forEach((mountNode) => {
    directMountComponent(component, mountNode);
  });
}

export function directMountComponent(component, mountNode) {
  const props = getProps(mountNode);
  render(createElement(component, props), mountNode);
}

export function mountComponentWithRedux(component, reducers) {
  const mountNodes = getMountNodes(component);

  mountNodes.forEach((mountNode) => {
    const props = getProps(mountNode);
    const connectedComponent = connect((state) => state)(component);
    const middlewares = applyMiddleware(...getReduxMiddlewares());
    const store = createStore(reducers, props, middlewares);

    render (
      <Provider store={store}>
        {createElement(connectedComponent)}
      </Provider>
    , mountNode);
  });
}

export function getMountNodes(component) {
  const selector = `[data-component="${component.componentName}"]`;
  return [].slice.call(document.querySelectorAll(selector));
}

function getReduxMiddlewares() {
  let middlewareList = [thunk];
  if (process.env.NODE_ENV !== "production" && !/PhantomJS/.test(window.navigator.userAgent)) {
    middlewareList.push(createLogger());
  }
  return middlewareList;
}

function getProps(node) {
  return getData(node, "component");
}
