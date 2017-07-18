import React, { PropTypes } from 'react';

const AddingNode = (props) => (
  <li
    className="tree__node"
    onClick={props.onClick}
  >
    <div className="tree__item--no-children">
      <div className="tree__item-body">
        ＋追加
      </div>
    </div>
  </li>
);

AddingNode.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default AddingNode;
