import flatten from 'lodash/flatten'
import findIndex from 'lodash/findIndex'
import find from 'lodash/find'
import isEmpty from 'is-empty'

export const isDescendantDecisionBranch = (node, id) => {
  const children = node.decisionBranches || node.childDecisionBranches || []
  let result = false
  children.forEach(child => {
    if (child.id === id) {
      result = true
    } else if (!result) {
      result = isDescendantDecisionBranch(child, id)
    }
  })
  return result
}

export const findQuestionAnswerFromTree = (tree, id) => (
  tree.filter(node => node.id === id)[0]
)

export const findDecisionBranchFromTree = (questionsTree, decisionBranchId, foundCallback) => {
  const handler = (decisionBranchNodes) => {
    decisionBranchNodes.forEach(decisionBranchNode => {
      if (decisionBranchNode.id === decisionBranchId) {
        foundCallback(decisionBranchNode)
      } else {
        handler(decisionBranchNode.childDecisionBranches)
      }
    })
  }
  const decisionBranchNodes = flatten(questionsTree.map(n => n.decisionBranches))
  handler(decisionBranchNodes)
}

export const findDecisionBranchFromTreePromise = (tree, decisionBranchId) => {
  return new Promise((resolve, reject) => {
    const handler = (decisionBranchNodes) => {
      decisionBranchNodes.forEach(decisionBranchNode => {
        if (decisionBranchNode.id === decisionBranchId) {
          return resolve(decisionBranchNode)
        } else {
          handler(decisionBranchNode.childDecisionBranches)
        }
      })
    }
    const decisionBranchNodes = flatten(tree.map(n => n.decisionBranches))
    handler(decisionBranchNodes)
  })
}

export const findDecisionBranchFromTreeWithChildId = (questionsTree, childDecisionBranchId, foundCallback) => {
  const handler = (targetNode) => {
    const { decisionBranches, childDecisionBranches } = targetNode
    const nodes = decisionBranches || childDecisionBranches || []
    const exists = find(nodes, (decisionBranchNode => (
      decisionBranchNode.id === childDecisionBranchId
    )))
    if (!isEmpty(exists)) {
      foundCallback(targetNode)
    } else {
      nodes.forEach(node => handler(node))
    }
  }
  questionsTree.forEach(node => handler(node))
}

export const getFlatTreeFromDecisionBranchId = (tree, decisionBranchId) => {
  return new Promise((resolve, reject) => {
    findDecisionBranchFromTreePromise(tree, decisionBranchId)
      .then(targetNode => {
        if (!isEmpty(targetNode.parentQuestionAnswerId)) {
          const qNode = findQuestionAnswerFromTree(tree, targetNode.parentQuestionAnswerId)
          resolve([qNode, targetNode])
        }
        else if (!isEmpty(targetNode.parentDecisionBranchId)) {
          let nodes = [targetNode]
          let handler = (parentDBId) => {
            findDecisionBranchFromTreePromise(tree, parentDBId).then(node => {
              nodes.push(node)
              if (!isEmpty(node.parentDecisionBranchId)) {
                handler(node.parentDecisionBranchId)
              } else if (!isEmpty(node.parentQuestionAnswerId)) {
                nodes.push(findQuestionAnswerFromTree(tree, node.parentQuestionAnswerId))
                resolve(nodes)
              }
            })
          }
          handler(targetNode.parentDecisionBranchId)
        }
      })
  })
}

export const makeNewDecisionBranch = () => ({ id: null, childDecisionBranches: [] })

export const deleteDecisionBranch = (nodes, id) => {
  const index = findIndex(nodes, (it) => it.id === id)
  nodes.splice(index, 1)
}

export const setDecisionBranch = (parentNode, key, newItem) => {
  const target = parentNode[key].filter(it => isEmpty(it.id))[0] || {}
  target.id = newItem.id
}

export const addArrayItem = (obj, key, item) => {
  if (isEmpty(obj)) { return }
  obj[key] = obj[key] || []
  obj[key].push(item)
}

export const makeNodeIdsFromNode = (node) => {
  if (Array.isArray(node.decisionBranches)) {
    return [`Question-${node.id}`, `Answer-${node.id}`]
  } else if (Array.isArray(node.childDecisionBranches)) {
    return [`DecisionBranch-${node.id}`, `DecisionBranchAnswer-${node.id}`]
  }
}

export const calcPercentile = (offsetHeight, scrollHeight, scrollTop) => {
  if (scrollTop === 0) { return 0 }
  if (scrollTop + offsetHeight === scrollHeight) { return 1 }
  return (scrollTop + offsetHeight) / scrollHeight
}