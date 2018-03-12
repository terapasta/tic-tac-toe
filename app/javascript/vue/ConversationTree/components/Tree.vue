<script>
import { mapState, mapActions } from 'vuex'
import chunk from 'lodash/chunk'

import QuestionNode from './QuestionNode'
import classnames from 'classnames'

export default {
  name: 'tree',

  props: {
    currentNodes: { type: Array, default: () => ([]) }
  },

  components: {
    QuestionNode
  },

  computed: {
    ...mapState([
      'isOnlyShowHasDecisionBranchesNode'
    ]),

    isActiveAddButton () {
      return this.$route.name === 'QuestionNew'
    },

    addButtonClassName () {
      return classnames('tree__item--no-children', {
        active: this.isActiveAddButton
      })
    }
  },

  methods: {
    ...mapActions([
      'toggleIsOnlyShowHasDecisionBranchesNode'
    ]),

    handleCheckBoxChange () {
      this.toggleIsOnlyShowHasDecisionBranchesNode()
    }
  }
}
</script>

<template>
  <ol class="tree">
    <li class="tree__node" id="adding">
      <label>
        <input
          type="checkbox"
          :checked="isOnlyShowHasDecisionBranchesNode"
          @change="handleCheckBoxChange"
        />
        &nbsp;
        <span class="icon-circle">
          <i class="material-icons upside-down" title="選択肢" style="top:-1px">call_split</i>
        </span>
        ツリーのみ表示
      </label>
      <br />
      <div :class="addButtonClassName">
        <router-link
          id="AddQuestionAnswerButton"
          class="tree__item-body"
          to="/question/new"
        >＋追加</router-link>
      </div>
    </li>
    <template v-for="node in currentNodes">
      <question-node :node="node" :key="node.id" />
    </template>
  </ol>
</template>
