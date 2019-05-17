import React, { Component, PropTypes } from "react";
import isEmpty from "is-empty";
import classNames from "classnames";

export class PanelHead extends Component {
  render() {
    const { title } = this.props;
    if (isEmpty(title)) { return null; }

    return (
      <div className="panel-heading">
        <div className="panel-title">{title}</div>
      </div>
    );
  }
}

class Panel extends Component {
  render() {
    const { title, modifier, children, isClickable, onClickBody, id } = this.props;
    const className = classNames("panel", {
      "panel-default": modifier == null || modifier === "default",
      "panel-danger": modifier === "danger",
    });

    return (
      <div className={className} id={id}>
        <PanelHead {...{ title }} />
        {isClickable && (
          <a {...{
            className: "panel-body",
            href: "#",
            style: { display: "block"},
            onClick: onClickBody,
          }}>{children}</a>
        )}
        {!isClickable && (
          <div className="panel-body">
            {children}
          </div>
        )}
      </div>
    );
  }
}

Panel.propTypes = {
  title: PropTypes.string,
};

export default Panel;
