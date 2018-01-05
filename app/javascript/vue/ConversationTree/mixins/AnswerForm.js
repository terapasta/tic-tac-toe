export default {
  methods: {
    handleAddDecisionBranchButtonClick () {
      let questionAnswerId, decisionBranchId
      switch (this.$route.name) {
        case 'Answer':
        case 'DecisionBranchAnswer':
          questionAnswerId = this.currentId
          break
        case 'DecisionBranch':
          decisionBranchId = this.currentId
          break
        default:
          break
      }
      this.addDecisionBranch({
        questionAnswerId,
        decisionBranchId
      })
    }
  }
}