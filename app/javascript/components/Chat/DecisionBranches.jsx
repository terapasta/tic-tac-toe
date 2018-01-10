import React, { Component } from 'react'
import PropTypes from 'prop-types'

const LengthThreshold = 20

export default class ChatDecisionBranches extends Component {
  static get propTypes() {
    return {
      title: PropTypes.string.isRequired,
      items: PropTypes.array.isRequired,
      onChoose: PropTypes.func.isRequired,
      selectAttribute: PropTypes.string.isRequired,
    }
  }

  itemClassName (body) {
    const align = (body || '').length > LengthThreshold ? 'text-left' : ''
    return `chat-decision-branches__item ${align}`
  }

  render() {
    const {
      title,
      items,
      onChoose,
      selectAttribute,
    } = this.props

    return (
      <div className="chat-decision-branches">
        <div className="chat-decision-branches__container">
          <div className="chat-decision-branches__title">
            {title}
          </div>
          <div className="chat-decision-branches__items">
            {items.map((item, i) => (
              <a className={this.itemClassName(item.body)}
                href="#"
                key={i}
                onClick={(e) => {
                  e.preventDefault()
                  onChoose(item[selectAttribute])
                }}>
                {item.body}
              </a>
            ))}
          </div>
        </div>
      </div>
    )
  }
}
