import React, { Component } from 'react'
import PreventWheelScrollOfParent from '../PreventWheelScrollOfParent'

class ChatArea extends Component {
  constructor(props) {
    super(props)
    this.handleWheel = this.handleWheel.bind(this)
  }

  render() {
    const { children, innerRef } = this.props

    return (
      <PreventWheelScrollOfParent className="chat-area" innerRef={innerRef}>
        {children}
      </PreventWheelScrollOfParent>
    );
  }

  handleWheel (e) {
    console.log(e)
  }
}

export default ChatArea
