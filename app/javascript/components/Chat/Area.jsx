import React, { Component } from 'react'
import PreventWheelScrollOfParent from '../PreventWheelScrollOfParent'

const HeaderHeight = 47
const FormHeight = 58

class ChatArea extends Component {
  constructor (props) {
    super(props)
    this.state = {
      height: null
    }
    this.handleWindowResize = this.handleWindowResize.bind(this)
  }

  componentDidMount () {
    this.handleWindowResize()
    window.addEventListener('resize', this.handleWindowResize)
  }

  componentWillUnmount () {
    window.removeEventListener('resize', this.handleWindowResize)
  }

  handleWindowResize () {
    const height = window.innerHeight - HeaderHeight - FormHeight
    this.setState({ height })
  }

  render () {
    const { innerref, children } = this.props
    const { height } = this.state
    let style = {}

    if (height) {
      style.height = `${height}px`
    }

    return (
      <PreventWheelScrollOfParent
        className="chat-area"
        innerref={innerref}
        style={style}
      >
        {children}
      </PreventWheelScrollOfParent>
    )
  }
}

export default ChatArea
