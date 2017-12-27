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