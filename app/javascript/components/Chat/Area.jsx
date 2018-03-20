import React, { Component } from 'react'
import bindAll from 'lodash/bindAll'
import values from 'lodash/values'
import incldues from 'lodash/includes'
import PreventWheelScrollOfParent from '../PreventWheelScrollOfParent'

const HeaderHeight = 47
const FormHeight = 58

const KeyMap = {
  Home: 36,
  End: 35,
  PageUp: 33,
  PageDown: 34,
  Up: 38,
  Down: 40
}

class ChatArea extends Component {
  constructor (props) {
    super(props)
    this.state = {
      height: null
    }
    bindAll(this, [
      'handleWindowResize',
      'handleDocumentKeyup'
    ])
  }

  componentDidMount () {
    this.handleWindowResize()
    window.addEventListener('resize', this.handleWindowResize)
    window.addEventListener('keydown', this.handleDocumentKeyup)
  }

  componentWillUnmount () {
    window.removeEventListener('resize', this.handleWindowResize)
    window.removeEventListener('keydown', this.handleDocumentKeyup)
  }

  handleWindowResize () {
    const height = window.innerHeight - HeaderHeight - FormHeight
    this.setState({ height })
  }

  handleDocumentKeyup (e) {
    if (!incldues(values(KeyMap), e.keyCode)) { return }
    if (this.areaNode) { this.areaNode.focus() }
  }

  render () {
    const { innerref, children } = this.props
    const { height } = this.state
    let style = {
      position: 'absolute',
      top: HeaderHeight,
      left: 0,
      right: 0
    }

    if (height) {
      style.height = `${height}px`
    }

    return (
      <PreventWheelScrollOfParent
        className="chat-area"
        innerref={node => {
          if (typeof innerref === 'function') {
            innerref(node)
          }
          this.areaNode = node
        }}
        style={style}
      >
        {children}
      </PreventWheelScrollOfParent>
    )
  }
}

export default ChatArea
