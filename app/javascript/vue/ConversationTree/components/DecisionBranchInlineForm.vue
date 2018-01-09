<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import toastr from 'toastr'

import DecisionBranchFormMixin from '../mixins/DecisionBranchForm'

export default {
  mixins: [DecisionBranchFormMixin],

  props: {
    nodeData: { type: Object, default: () => ({}) },
    index: { type: Number, default: null },
    questionAnswerId: { type: Number, default: null },
    decisionBranchId: { type: Number, default: null }
  },

  data: () => ({
    isEditing: false
  }),

  computed: {
    isNew () {
      return isEmpty(this.nodeData.id)
    }
  },

  methods: {
    ...mapActions([
      'createDecisionBranch',
      'updateDecisionBranch',
      'deleteDecisionBranch'
    ]),

    handleCreateButtonClick () {
      const { questionAnswerId, decisionBranchId } = this
      const { body } = this.nodeData
      this.createDecisionBranch({
        questionAnswerId,
        decisionBranchId,
        body
      }).then(() => {
        toastr.success('選択肢を追加しました')
      }).catch(() => {
        toastr.error('選択肢を追加できませんでした', 'エラー')
      })
    },

    handleUpdateButtonClick () {
      const { questionAnswerId, index } = this
      const { id, body } = this.nodeData
      this.updateDecisionBranch({
        questionAnswerId,
        index,
        body,
        decisionBranchId: id
      }).then(() => {
        toastr.success('選択肢を更新しました')
        this.isEditing = false
      }).catch(() => {
        toastr.error('選択肢を更新できませんでした', 'エラー')
      })
    },

    handleEditButtonClick () {
      this.isEditing = true
    },

    handleCancelEditButtonClick () {
      this.isEditing = false
    }
  }
}
</script>

<template>
  <div>
    <span v-if="!isNew && !isEditing">{{nodeData.body}}</span>
    <button
      v-if="!isNew && !isEditing"
      class="btn btn-link"
      @click.prevent="handleEditButtonClick"
    ><i class="material-icons mi-xs">edit</i></button>
    <div class="input-group">
      <input
        v-if="isNew || isEditing"
        class="form-control"
        placeholder="選択肢を入力"
        name="decision-branch-body"
        v-model="nodeData.body"
        autofocus
      />
      <span class="input-group-btn">
        <button
          v-if="isNew"
          class="btn btn-success"
          @click.prevent="handleCreateButtonClick"
        >追加</button>
        <button
          v-if="!isNew && isEditing"
          class="btn btn-success"
          @click.prevent="handleUpdateButtonClick"
        >保存</button>
        <button
          v-if="!isNew && isEditing"
          class="btn btn-danger"
          @click.prevent="handleDeleteButtonClick"
        >削除</button>
        <button
          v-if="!isNew && isEditing"
          class="btn btn-secondary"
          @click.prevent="handleCancelEditButtonClick"
        >キャンセル</button>
      </span>
    </div>
  </div>
</template>