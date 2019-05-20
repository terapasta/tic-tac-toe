import React, { Component } from 'react'
import classNames from 'classnames'

class Popover extends Component {
  constructor (props) {
    super(props)
    this.state = {
    }
    this.handleClick = this.handleClick.bind(this)
  }

  handleClick (e) {
    e.stopPropagation()
  }

  render () {
    const { children, title, fadeIn } = this.props
    const className = classNames('chat-popover', {
      'Animate-fadeIn': fadeIn
    })

    return (
      <div className={className} onClick={this.handleClick}>
        <div className="chat-popover__title">
          {title}
        </div>
        {children}
      </div>
    )
  }
}

Popover.propTypes = {
}

export default Popover