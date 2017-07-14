import { PropTypes } from 'react';
import assign from 'lodash/assign';

function treePropType(baseShape, childKey) {
  const shape = assign({}, baseShape, {
    [childKey]: PropTypes.arrayOf(lazyType),
  });
  const type = PropTypes.shape(shape);
  const lazyType = lazyFunction(() => PropTypes.arrayOf(type));
  return lazyType;
}

function lazyFunction(f) {
  return function (...args) {
    return f().apply(this, args);
  };
}

export const decisionBranchTreePropType = treePropType({
  id: PropTypes.number.isRequired,
}, 'childDecisionBranches');

export const openedNodesType = PropTypes.shape({
  questionIds: PropTypes.arrayOf(PropTypes.number),
  answerIds: PropTypes.arrayOf(PropTypes.number),
  decisionBranchIds: PropTypes.arrayOf(PropTypes.number),
});
