<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import toastr from 'toastr'
import get from 'lodash/get'

import DecisionBranchFormMixin from '../mixins/DecisionBranchForm'

export default {
  mixins: [DecisionBranchFormMixin],

  props: {
    nodeData: { type: Object, default: () => ({}) },
    isFirst: { type: Boolean, default: false },
    isLast: { type: Boolean, default: false },
    questionAnswerId: { type: Number, default: null },
    decisionBranchId: { type: Number, default: null }
  },

  data: () => ({
    isEditing: false
  }),

  computed: {
    ...mapState([
      'decisionBranchesRepo'
    ]),

    isNew () {
      return isEmpty(this.nodeData.id)
    },

    answerFiles () {
      return get(this.nodeData, 'answerFiles', [])
    }
  },

  methods: {
    ...mapActions([
      'createDecisionBranch',
      'updateDecisionBranch',
      'deleteDecisionBranch',
      'moveDecisionBranchToHigherPosition',
      'moveDecisionBranchToLowerPosition'
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
      const db = this.decisionBranchesRepo[id]
      this.updateDecisionBranch({
        questionAnswerId,
        index,
        body,
        decisionBranchId: id,
        answer: db.answer
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
    },

    handleSortUpButtonClick () {
      const { id } = this.nodeData
      this.moveDecisionBranchToHigherPosition({ decisionBranchId: id })
    },

    handleSortDownButtonClick () {
      const { id } = this.nodeData
      this.moveDecisionBranchToLowerPosition({ decisionBranchId: id })
    }
  }
}
</script>

<template>
  <div :id="`DecisionBranchItem-${nodeData.id}`">
    <span v-if="!isNew && !isEditing">{{nodeData.body}}</span>
    <router-link :to="`/decisionBranch/${nodeData.id}`">
      <i
        v-if="answerFiles.length > 0"
        class="material-icons"
        alt="添付ファイルがあります"
        title="添付ファイルがあります"
      >attachment</i>
    </router-link>
    <button
      v-if="!isNew && !isEditing"
      class="btn btn-link"
      @click.prevent="handleEditButtonClick"
    ><i class="material-icons mi-xs">edit</i></button>
    <div class="sort-btns" v-if="!isNew && !isEditing">
      <button
        v-if="!isFirst"
        class="sort-btn-up"
        @click="handleSortUpButtonClick"
        :id="`DecisionBranch-${nodeData.id}-moveHigherButton`"
      ><i class="material-icons">keyboard_arrow_up</i></button>
      <span v-if="isFirst" class="sort-btn-placeholder-up" />
      <button
        v-if="!isLast"
        class="sort-btn-down"
        @click="handleSortDownButtonClick"
        :id="`DecisionBranch-${nodeData.id}-moveLowerButton`"
      ><i class="material-icons">keyboard_arrow_down</i></button>
      <span v-if="isLast" class="sort-btn-placeholder-down" />
    </div>
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

<style scoped lang="scss">
.sort-btns {
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;

  %base-sort-btn {
    border: 0;
    border-left: 1px solid #efefef;
    background: transparent;
    display: block;
    padding: 0;
    width: 45px;
    height: 50%;
    cursor: pointer;

    &:hover {
      background-color: #efefef;
    }
  }

  .sort-btn-up {
    @extend %base-sort-btn;
    border-bottom: 1px solid #efefef;
  }
  .sort-btn-down {
    @extend %base-sort-btn;
  }

  %base-sort-btn-placeholder {
    @extend %base-sort-btn;
    cursor: default;
    &:hover {
      background-color: #fff;
    }
  }
  .sort-btn-placeholder-up {
    @extend %base-sort-btn-placeholder;
    border-bottom: 1px solid #efefef;
  }
  .sort-btn-placeholder-down {
    @extend %base-sort-btn-placeholder;
  }
}
</style>