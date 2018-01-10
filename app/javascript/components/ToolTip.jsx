import React, { Component } from 'react'
import PropTypes from 'prop-types'

import getOffset from '../helpers/getOffset'

const makeTip = title => {
  const tip = document.createElement('div')
  tip.setAttribute('class', 'tooltip bs-tooltip-top show')
  const arrow = document.createElement('div')
  arrow.setAttribute('class', 'arrow')
  arrow.style.left = '50%'
  tip.appendChild(arrow)
  const inner = document.createElement('div')
  inner.setAttribute('class', 'tooltip-inner')
  inner.innerText = title
  tip.appendChild(inner)
  return tip
}

class ToolTip extends Component {
  constructor(props) {
    super(props)
    this.handleMouseEnter = this.handleMouseEnter.bind(this)
    this.handleMouseLeave = this.handleMouseLeave.bind(this)
  }

  handleMouseEnter (e) {
    const { title } = this.props
    this.tip = makeTip(title)
    document.body.appendChild(this.tip)
    const elWidth = window.parseInt(window.getComputedStyle(this.el).width.replace(/px/, ''))
    const offset = getOffset(this.el)
    const top = offset.top - this.tip.offsetHeight
    const left = (offset.left + elWidth / 2) - this.tip.offsetWidth / 2
    this.tip.style.top = `${top}px`
    this.tip.style.left = `${left}px`
  }

  handleMouseLeave (e) {
    this.tip.remove()
  }

  render () {
    const { children } = this.props
    return <div
      ref={node => this.el = node}
      onMouseEnter={this.handleMouseEnter}
      onMouseLeave={this.handleMouseLeave}
    >{children}</div>
  }
}

ToolTip.propTypes = {
  children: PropTypes.node.isRequired
}

export default ToolTip
