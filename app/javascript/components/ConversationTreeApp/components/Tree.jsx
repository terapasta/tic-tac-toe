import React, { Component } from 'react';
import PropTypes from 'prop-types'

class Tree extends Component {
  render() {
    const { children, isOpened } = this.props;
    const style = {
      display: isOpened ? 'block' : 'none',
    };

    return (
      <ol className="tree" style={style}>
        {children}
      </ol>
    );
  }
}

Tree.propTypes = {
  children: PropTypes.node.isRequired,
  isOpened: PropTypes.bool,
};

Tree.defaultProps = {
  isOpened: true,
};

export default Tree;
