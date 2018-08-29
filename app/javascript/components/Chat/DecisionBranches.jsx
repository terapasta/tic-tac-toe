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
      isSortable: PropTypes.bool,
      onInitialQuestionPositionChange: PropTypes.func,
      isManager: PropTypes.bool
    }
  }

  itemClassName (body) {
    // see: https://www.pivotaltracker.com/n/projects/1879711/stories/159879196
    const align = 'text-left'
    return `chat-decision-branches__item ${align}`
  }

  handleUpClick (index) {
    if (index === 0) { return }
    const { onInitialQuestionPositionChange } = this.props
    onInitialQuestionPositionChange(index, 'up')
  }

  handleDownClick (index) {
    const { items, onInitialQuestionPositionChange } = this.props
    if (index === items.length - 1) { return }
    onInitialQuestionPositionChange(index, 'down')
  }

  render() {
    const {
      title,
      items,
      onChoose,
      selectAttribute,
      isSortable,
      isManager,
    } = this.props

    return (
      <div className="chat-decision-branches">
        <div className="chat-decision-branches__container">
          <div className="chat-decision-branches__title">
            {title}
          </div>
          <div className="chat-decision-branches__items">
            {items.map((item, i) => (
              <div className={this.itemClassName(item.body)} key={i}>
                <a
                  href="#"
                  onClick={(e) => {
                    e.preventDefault()
                    onChoose(item[selectAttribute], item)
                  }}>
                  {item.body}
                </a>
                {isManager && isSortable && (i !== 0) && (
                  <button
                    className="chat-decision-branches__up"
                    onClick={() => this.handleUpClick(i)}
                  >
                    <i className="material-icons">keyboard_arrow_up</i>
                  </button>
                )}
                {isManager && isSortable && (i !== items.length - 1) && (
                  <button
                    className="chat-decision-branches__down"
                    onClick={() => this.handleDownClick(i)}
                  >
                    <i className="material-icons">keyboard_arrow_down</i>
                  </button>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>
    )
  }
}
