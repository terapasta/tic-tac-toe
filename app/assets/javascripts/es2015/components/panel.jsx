import React, { Component, PropTypes } from "react";
import isEmpty from "is-empty";
import classNames from "classnames";

export function PanelHead(props) {
  const { title } = props;
  if (isEmpty(title)) { return null; }

  return (
    <div className="panel-heading">
      <div className="panel-title">{title}</div>
    </div>
  );
}

function Panel(props) {
  const { title, modifier, children } = props;
  const className = classNames("panel", {
    "panel-default": modifier == null || modifier === "default",
    "panel-danger": modifier === "danger",
  });

  return (
    <div className={className}>
      <PanelHead {...{ title }} />
      <div className="panel-body">
        {children}
      </div>
    </div>
  );
}

Panel.propTypes = {
  title: PropTypes.string,
};

export default Panel;
