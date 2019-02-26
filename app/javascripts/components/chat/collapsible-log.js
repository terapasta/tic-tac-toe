import React, { Component } from 'react'
import classnames from 'classnames'

class CollapsibleLog extends Component {
  constructor(props) {
    super(props)
    this.state = {
      isActive: false
    }
  }

  render() {
    const { isActive } = this.state
    const { obj } = this.props

    const classNames = classnames('collapsible', { active: isActive })

    return (
      <div
        className={classNames}
        onDoubleClick={() => this.setState({ isActive: !isActive })}
        style={{ textAlign: 'left' }}
        title="ダブルクリックで開閉します"
      >
        <pre>
          {JSON.stringify(obj, null, 2)}
        </pre>
      </div>
    )
  }
}

export default CollapsibleLog