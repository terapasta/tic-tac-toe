import React, { Component, PropTypes } from 'react';
import { findDOMNode } from 'react-dom';
import assign from 'lodash/assign';
import keys from 'lodash/keys';
import includes from 'lodash/includes';
import pickBy from 'lodash/pickBy';

class PreventWheelScrollOfParent extends Component {
  constructor(props) {
    super(props);
    this.onWheelWrapper = this.onWheelWrapper.bind(this);
  }

  onWheelWrapper(e) {
    const wrapper = findDOMNode(this.wrapper);
    const { offsetHeight, scrollHeight, scrollTop } = wrapper;
    const isDown = e.deltaY > 0;
    const isUp = !isDown;
    const isBottom = isDown && scrollTop + offsetHeight >= scrollHeight;
    const isTop = isUp && scrollTop === 0;

    if (isBottom || isTop) {
      e.preventDefault();
    }
  }

  render() {
    const { children, type } = this.props;

    const customProps = pickBy(this.props, (val, key) => {
      return !includes(keys(PreventWheelScrollOfParent.propTypes), key);
    });

    const resolvedProps = assign({}, customProps, {
      ref: node => {
        this.wrapper = node
        if (typeof customProps.innerRef === 'function') {
          customProps.innerRef(node)
        }
      },
      onWheel: this.onWheelWrapper,
    });

    return React.createElement(type, resolvedProps, children);
  }
}

PreventWheelScrollOfParent.propTypes = {
  children: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.element),
    PropTypes.element,
  ]).isRequired,
  type: PropTypes.string,
};

PreventWheelScrollOfParent.defaultProps = {
  type: 'div',
};

export default PreventWheelScrollOfParent;
