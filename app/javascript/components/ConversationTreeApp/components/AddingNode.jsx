import React from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'

import { activeItemType } from '../types'

const className = props => classnames('tree__item--no-children', {
  active: props.activeItem.nodeKey === null && props.activeItem.type === 'question',
});

const AddingNode = (props) => (
  <li
    className="tree__node"
    onClick={props.onClick}
    id="adding"
  >
    <div className={className(props)}>
      <div className="tree__item-body">
        ＋追加
      </div>
    </div>
  </li>
);

AddingNode.propTypes = {
  activeItem: activeItemType.isRequired,
  onClick: PropTypes.func.isRequired,
};

export default AddingNode;
