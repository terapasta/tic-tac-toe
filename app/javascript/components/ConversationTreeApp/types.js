import PropTypes from 'prop-types'
import assign from 'lodash/assign'

const {
  shape,
  string,
  number,
  arrayOf,
  object,
  array,
} = PropTypes

// export const decisionBranchTreePropType = treePropType({
//   id: number.isRequired,
// }, 'childDecisionBranches')
export const decisionBranchTreePropType = arrayOf(shape({
  id: number.isRequired,
  childDecisionBranches: array
}))

export const questionsTreeType = arrayOf(shape({
  id: number.isRequired,
  decisionBranches: decisionBranchTreePropType,
}))

export const openedNodesType = arrayOf(string)

export const activeItemType = shape({
  type: string,
  nodeKey: string,
  node: shape({
    id: number,
    decisionBranches: decisionBranchTreePropType,
  })
})

export const questionsRepoType = shape({
  [number]: shape({
    id: number,
    question: string,
    answer: string,
  })
})

export const questionNodeType = shape({
  id: number.isRequired,
  decisionBranches: decisionBranchTreePropType,
})

export const decisionBranchType = shape({
  id: number,
  answer: string,
  childDecisionBranches: arrayOf(object),
})

export const decisionBranchesRepoType = shape({
  [number]: decisionBranchType,
})

function treePropType(baseShape, childKey) {
  const lazyType = lazyFunction(() => arrayOf(type))
  const nodeShape = assign({}, baseShape, {
    [childKey]: arrayOf(lazyType),
  })
  const type = shape(nodeShape)
  return lazyType
}

function lazyFunction(f, _lazyCheckerHasSeen) {
  return function () {
    if (_lazyCheckerHasSeen !== undefined &&
        _lazyCheckerHasSeen.indexOf(arguments[0]) !== -1) {
      return true;
    }

    if (_lazyCheckerHasSeen !== undefined) {
      _lazyCheckerHasSeen.push(arguments[0])
    }
    return f().apply(this, arguments)
  }
}
