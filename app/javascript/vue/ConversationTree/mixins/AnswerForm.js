export default {
  methods: {
    handleAddDecisionBranchButtonClick () {
      let questionAnswerId, decisionBranchId
      switch (this.$route.name) {
        case 'Answer':
          questionAnswerId = this.currentId
          break
        case 'DecisionBranch':
        case 'DecisionBranchAnswer':
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