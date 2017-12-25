import React from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import classnames from 'classnames'
import values from 'lodash/values'

const TabTypes = {
  Textarea: 'textarea',
  Selector: 'selector'
}

const Label = styled.label.attrs({
  className: "mb-0"
})`
  width: 80px;
  padding-top: 8px;
`

const Ul = styled.ul.attrs({
  className: 'nav nav-tabs'
})`
  width: 100%;
`

const commonPropTypes = {
  currentType: PropTypes.oneOf(values(TabTypes))
}
const commonDefaultProps = {
  currentType: TabTypes.Textarea
}

const NavItem = props => (
  <li className="nav-item">
    <a
      className={classnames('nav-link', {
        active: props.currentType === props.type
      })}
      onClick={(e) => {
        e.preventDefault()
        props.onClick()
      }}
      href="#"
    >
      {props.children}
    </a>
  </li>
)

const TabNav = props => (
  <div className="d-flex mb-2">
    <Label>
      <i className="material-icons" title="質問">chat_bubble_outline</i> 回答
    </Label>
    <Ul>
      <NavItem
        type={TabTypes.Textarea}
        currentType={props.currentType}
        onClick={() => props.onClick(TabTypes.Textarea)}
      >
        入力する
      </NavItem>
      <NavItem
        type={TabTypes.Selector}
        currentType={props.currentType}
        onClick={() => props.onClick(TabTypes.Selector)}
      >
        選択する
      </NavItem>
    </Ul>
  </div>
)
TabNav.propTypes = commonPropTypes
TabNav.defaultProps = commonDefaultProps

const TabTextareaContent = props => {
  if (props.currentType !== TabTypes.Textarea) { return null }
  return <div>{props.children}</div>
}
TabTextareaContent.propTypes = commonPropTypes
TabTextareaContent.defaultProps = commonDefaultProps

const TabSelectorContent = props => {
  if (props.currentType !== TabTypes.Selector) { return null }
  return <div>{props.children}</div>
}
TabSelectorContent.propTypes = commonPropTypes
TabSelectorContent.defaultProps = commonDefaultProps

export { TabNav, TabTextareaContent, TabSelectorContent }