import React from 'react'
import PreventWheelScrollOfParent from '../PreventWheelScrollOfParent'

const ChatArea = props => (
  <PreventWheelScrollOfParent className="chat-area" innerref={props.innerref}>
    {props.children}
  </PreventWheelScrollOfParent>
)

export default ChatArea
