import React, { Component, PropTypes } from "react";

export default class ChatDecisionBranches extends Component {
  static get propTypes() {
    return {
      title: PropTypes.string.isRequired,
      items: PropTypes.array.isRequired,
      onSelect: PropTypes.func.isRequired,
    };
  }

  render() {
    const {
      title,
      items,
      onSelect,
    } = this.props;

    return (
      <div className="chat-decision-branches">
        <div className="chat-decision-branches__container">
          <div className="chat-decision-branches__title">
            {title}
          </div>
          <div className="chat-decision-branches__items">
            {items.map((item, i) => (
              <a className="chat-decision-branches__item"
                href="#"
                key={i}
                onClick={(e) => {
                  e.preventDefault();
                  onSelect(i, item);
                }}>
                {item.body}
              </a>
            ))}
          </div>
        </div>
      </div>
    );
  }
}
