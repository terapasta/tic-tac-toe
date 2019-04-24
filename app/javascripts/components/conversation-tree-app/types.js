import { PropTypes } from 'react';
import assign from 'lodash/assign';

const {
  shape,
  string,
  number,
  arrayOf,
  object,
} = PropTypes;

export const decisionBranchTreePropType = treePropType({
  id: number.isRequired,
}, 'childDecisionBranches');

export const questionsTreeType = arrayOf(shape({
  id: number.isRequired,
  decisionBranches: decisionBranchTreePropType,
}));

export const openedNodesType = arrayOf(string);

export const activeItemType = shape({
  type: string,
  nodeKey: string,
  node: shape({
    id: number,
    decisionBranches: decisionBranchTreePropType,
  }),
});

export const questionsRepoType = shape({
  [number]: shape({
    id: number,
    question: string,
    answer: string,
  }),
});

export const questionNodeType = shape({
  id: number.isRequired,
  decisionBranches: decisionBranchTreePropType,
});

export const decisionBranchType = shape({
  id: number,
  answer: string,
  childDecisionBranches: arrayOf(object),
});

export const decisionBranchesRepoType = shape({
  [number]: decisionBranchType,
});

function treePropType(baseShape, childKey) {
  const nodeShape = assign({}, baseShape, {
    [childKey]: arrayOf(lazyType),
  });
  const type = shape(nodeShape);
  const lazyType = lazyFunction(() => arrayOf(type));
  return lazyType;
}

function lazyFunction(f) {
  return function (...args) {
    return f().apply(this, args);
  };
}
