import React, { Component, PropTypes } from "react";
import PreventWheelScrollOfParent from '../prevent-wheel-scroll-of-parent'

class ChatArea extends Component {
  constructor(props) {
    super(props)
    this.handleWheel = this.handleWheel.bind(this)
  }

  render() {
    const { children, innerRef } = this.props;

    return (
      <PreventWheelScrollOfParent className="chat-area" ref={innerRef}>
        {children}
      </PreventWheelScrollOfParent>
    );
  }

  handleWheel (e) {
    console.log(e)
  }
}

export default ChatArea;
