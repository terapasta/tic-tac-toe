import toastr from 'toastr'

export default {
  methods: {
    handleDeleteButtonClick () {
      const { questionAnswerId, decisionBranchId } = this
      const { id } = this.nodeData
      this.$swal({
        title: '本当に削除してよろしいですか？',
        text: 'この操作は取り消せません。配下の回答や選択肢も削除されます。',
        type: 'warning',
        showCancelButton: true
      }).then(() => {
        this.deleteDecisionBranch({
          questionAnswerId,
          decisionBranchId,
          targetDecisionBranchId: id
        }).then(() => {
          toastr.success('選択肢を削除しました')
          this.isEditing = false
          this.afterDelete()
        }).catch(() => {
          toastr.error('選択肢を削除できませんでした', 'エラー')
        })
      }).catch(this.$swal.noop)
    },

    afterDelete () {
      switch (this.$route.name) {
        case "DecisionBranch":
          return this.$router.push("/")
        case "Answer":
        case "DecisionBranchAnswer":
          return
        default:
          return
      }
    }
  }
}