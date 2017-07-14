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

export const questionNodeKey = id => `question-answer-${id}`;
export const answerNodeKey = id => `answer-${id}`;
export const decisionBranchNodeKey = id => `decision-branch-${id}`;
export const decisionBranchAnswerNodeKey = id => `decision-branch-answer-${id}`;
