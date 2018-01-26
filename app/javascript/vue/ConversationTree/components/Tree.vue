<script>
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
    isActiveAddButton () {
      return this.$route.name === 'QuestionNew'
    },

    addButtonClassName () {
      return classnames('tree__item--no-children', {
        active: this.isActiveAddButton
      })
    }
  }
}
</script>

<template>
  <ol class="tree">
    <li class="tree__node" id="adding">
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
  <!--<li class="tree__node" id="question-2">
    <div class="tree__item">
      <div class="tree__item-body"><i class="material-icons" title="質問">comment</i>ラーメン好き？</div>
    </div>
    <ol class="tree" style="display: none;">
      <li class="tree__node" id="answer-2">
        <div class="tree__item">
          <div class="tree__item-body"><i class="material-icons" title="質問">chat_bubble_outline</i>味噌ラーメン大好き</div>
        </div>
        <ol class="tree" style="display: none;">
          <div>
            <li class="tree__node" id="decision-branch-3">
              <div class="tree__item">
                <div class="tree__item-body"><i class="material-icons upside-down" title="選択肢">call_split</i>塩は？</div>
              </div>
              <ol class="tree" style="display: none;">
                <li class="tree__node" id="decision-branch-answer-3">
                  <div class="tree__item">
                    <div class="tree__item-body"><i class="material-icons" title="質問">chat_bubble_outline</i>それはない</div>
                  </div>
                  <ol class="tree" style="display: none;">
                    <li class="tree__node" id="decision-branch-5">
                      <div class="tree__item tree__item--no-children">
                        <div class="tree__item-body"><i class="material-icons upside-down" title="選択肢">call_split</i>なんでやー</div>
                      </div>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
            <li class="tree__node" id="decision-branch-4">
              <div class="tree__item">
                <div class="tree__item-body"><i class="material-icons upside-down" title="選択肢">call_split</i>醤油は？</div>
              </div>
              <ol class="tree" style="display: none;">
                <li class="tree__node" id="decision-branch-answer-4">
                  <div class="tree__item tree__item--no-children">
                    <div class="tree__item-body"><i class="material-icons" title="質問">chat_bubble_outline</i>ギリ許せる</div>
                  </div>
                </li>
              </ol>
            </li>
          </div>
        </ol>
      </li>
    </ol>
  </li>
  <li class="tree__node" id="question-1">
    <div class="tree__item">
      <div class="tree__item-body"><i class="material-icons" title="質問">comment</i>質問ですよー</div>
    </div>
    <ol class="tree" style="display: none;">
      <li class="tree__node" id="answer-1">
        <div class="tree__item">
          <div class="tree__item-body"><i class="material-icons" title="質問">chat_bubble_outline</i>回答ですよー</div>
        </div>
        <ol class="tree" style="display: none;">
          <div>
            <li class="tree__node" id="decision-branch-1">
              <div class="tree__item tree__item--no-children">
                <div class="tree__item-body"><i class="material-icons upside-down" title="選択肢">call_split</i>はい</div>
              </div>
            </li>
            <li class="tree__node" id="decision-branch-2">
              <div class="tree__item tree__item--no-children">
                <div class="tree__item-body"><i class="material-icons upside-down" title="選択肢">call_split</i>いいえ</div>
              </div>
            </li>
          </div>
        </ol>
      </li>
    </ol>
  </li>-->
</template>