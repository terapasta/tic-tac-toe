import React, { Component, PropTypes } from "react";
import classNames from "classnames";

export default class AddNode extends Component {
  static get componentName() {
    return "AddNode";
  }

  static get propTypes() {
    return {
      isAdding: PropTypes.bool.isRequired,
      onClick:  PropTypes.func.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
    };
  }

  render() {
    const {
      isAdding,
      onClick,
    } = this.props;

    const itemClassName = classNames("tree__item--no-children", {
      active: isAdding,
    });

    return (
      <li className="tree__node">
        <div className={itemClassName} onClick={onClick}>
          <div className="tree__item-add">＋追加</div>
        </div>
      </li>
    );
  }
}
