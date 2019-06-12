<script>
import format from 'date-fns/format'
import VueMarkdown from 'vue-markdown'
import isEmpty from 'is-empty'
import find from 'lodash/find'
import sortBy from 'lodash/sortBy'

import AnswerFiles from './AnswerFiles'
import QuestionOptions from './QuestionOptions'
import getOffset from '../../helpers/getOffset'
import Modal from '../Modal'
import initialSelectionsInstruction from './images/initial-questions-sample.png'
import InitialSelectionModal from './InitialSelectionModal'

export default {
  components: {
    AnswerFiles,
    QuestionOptions,
    VueMarkdown,
    Modal,
    InitialSelectionModal,
  },

  props: {
    bot: { type: Object },
    isAnimate: { type: Boolean, default: true },
    isStaff: { type: Boolean, default: false },
    isOwner: { type: Boolean, default: false },
    message: { type: Object, required: true },
  },

  data: () => ({
    localRating: null,
    isLogOpened: false,
    popoverStyle: {},
    shouldShowInitialSelectionModal: false,
    shouldShowHelpInitialSelection: false,
    initialSelectionsInstruction,
  }),

  computed: {
    isGuest () {
      return this.speaker === 'guest'
    },

    isBot () {
      return this.speaker === 'bot'
    },

    isGood () {
      return this.localRating === 'good' || this.message.rating === 'good'
    },

    isBad () {
      return this.localRating === 'bad' || this.message.rating === 'bad'
    },

    wrapperClass () {
      return { 'col-10': true, 'offset-2': this.isGuest }
    },

    balloonClass () {
      return `balloon balloon--${this.speaker}`
    },

    animationDuration () {
      return this.isAnimate ? 1000 : 0
    },

    formattedCreatedAt () {
      return format(this.message.createdAt, 'YYYY/MM/DD HH:mm')
    },

    body () {
      return this.message.body
    },

    speaker () {
      return this.message.speaker
    },

    similarQuestionAnswers () {
      const result = this.message.similarQuestionAnswers.map(it => {
        return { ...it, body: it.question }
      })
      return result
    },

    decisionBranches () {
      const { decisionBranches, childDecisionBranches } = this.message
      if (decisionBranches.length > 0) {
        return decisionBranches
      }
      if (childDecisionBranches.length > 0) {
        return childDecisionBranches
      }
      return []
    },

    hasInitialSelections () {
      return !isEmpty(this.message.initialSelections)
    },

    initialQuestions () {
      const results = sortBy(this.message.initialSelections, ['position'])
        .map(it => it.questionAnswer)
        .map(it => ({ ...it, body: it.question }))
      console.log({ results })
      return results
    }
  },

  methods: {
    handleVueMarkdownRendered (outHtml) {
    },

    handleDecisionBranchSelect (decisionBranch) {
      this.$emit('select-decision-branch', decisionBranch)
    },

    handleSimilarQuestionAnswerSelect (similarQuestionAnswer) {
      this.$emit('select-question', similarQuestionAnswer.question)
    },

    handleInitialQuestionSelect (initialQuestion) {
      this.$emit('select-question', initialQuestion.question)
    },

    handleGoodButtonClick () {
      this.localRating = 'good'
      this.$emit('good', this.message)
    },

    handleBadButtonClick () {
      this.localRating = 'bad'
      this.$emit('bad', this.message)
    },

    handleLogButtonClick () {
      this.isLogOpened = !this.isLogOpened
      const { logButton } = this.$refs
      const offset = getOffset(logButton)
      const rightEdgeX = offset.left + logButton.offsetWidth
      const width = rightEdgeX < 600 ? rightEdgeX : 600
      this.popoverStyle.width = `${width}px`
    },

    handleInitialQuestionMove (questionAnswer, direction) {
      const selection = find(this.message.initialSelections, it => {
        return it.questionAnswer.id === questionAnswer.id
      })
      this.$emit(`initial-selection-move-${direction}`, selection)
    }
  }
}
</script>

<template>
  <transition
    name="fade"
    appear
    :duration="animationDuration"
  >
    <div>
      <div class="container">
        <div class="row">
          <div :class="wrapperClass">
            <div v-if="isBot" class="speaker-info bot">
              <div class="avatar">
                <a :href="bot.image.url" target="_blank">
                  <img :src="bot.image.thumb.url" />
                </a>
              </div>
              <div class="text">
                <span>{{bot.name}}</span>
                <time class="d-inline-block">{{formattedCreatedAt}}</time>
              </div>
              <div
                v-if="isStaff"
                class="log-container"
              >
                <button
                  ref="logButton"
                  class="btn btn-light"
                  @click.prevent.stop="handleLogButtonClick"
                >
                  ログを{{isLogOpened ? '閉じる' : '見る'}}
                </button>
                <div
                  v-if="isLogOpened"
                  class="popover fade show bs-popover-bottom"
                  :style="popoverStyle"
                >
                  <div class="arrow" />
                  <h3 class="popover-header" />
                  <div class="popover-body">
                    <template v-if="message.replyLog">
                      <pre>{{JSON.stringify(message.replyLog, null, '  ')}}</pre>
                    </template>
                    <template v-else>
                      <div class="text-center">ログはありません</div>
                    </template>
                  </div>
                </div>
              </div>
            </div>

            <div v-if="isGuest" class="speaker-info guest">
              <div class="text">
                <time>{{formattedCreatedAt}}</time>
              </div>
            </div>

            <div :class="balloonClass">
              <vue-markdown
                v-if="isBot"
                class="bot-message-body"
                :source="body"
                :html="false"
                :emoji="false"
                :toc="false"
                :anchorAttributes="{
                  class: 'link',
                  target: '_blank'
                }"
                @rendered="handleVueMarkdownRendered"
              />
              <span v-else>{{body}}</span>
            </div>
          </div>
        </div>
      </div>

      <answer-files
        v-if="isBot && (message.answerFiles || []).length > 0"
        :answer-files="message.answerFiles"
      />

      <div class="container">
        <div class="row">
          <div :class="wrapperClass">
            <div v-if="isBot" class="feedback">
              <div class="desc">この回答を評価してください</div>
              <button @click.prevent.stop="handleGoodButtonClick">
                <i class="material-icons good" :class="{ active: isGood }">thumb_up</i>
              </button>
              <button @click.prevent.stop="handleBadButtonClick">
                <i class="material-icons bad" :class="{ active: isBad }">thumb_down</i>
              </button>
            </div>
          </div>
        </div>
      </div>


      <div
        class="container pt-4"
        v-if="decisionBranches.length > 0"
      >
        <div class="row justify-content-md-center">
          <div class="col-md-6">
            <question-options
              title="回答を選択してください"
              :items="decisionBranches"
              @select="handleDecisionBranchSelect"
            />
          </div>
        </div>
      </div>

      <div
        class="container pt-4"
        v-if="hasInitialSelections"
      >
        <div class="row justify-content-md-center">
          <div class="col-md-6">
            <question-options
              title="こちらの質問ではありませんか？"
              :items="initialQuestions"
              :order-editable="isStaff || isOwner"
              @select="handleInitialQuestionSelect"
              @move-higher="handleInitialQuestionMove($event, 'higher')"
              @move-lower="handleInitialQuestionMove($event, 'lower')"
            />
            <div v-if="isStaff || isOwner" class="d-flex align-items-center">
              <button
                class="btn btn-link"
                @click.stop.prevent="shouldShowInitialSelectionModal = true"
              >
                初期質問リストを編集する
              </button>
              <a href="#" @click.stop.prevent="shouldShowHelpInitialSelection = true">
                <i class="material-icons align-middle">help</i>
              </a>
            </div>
          </div>
        </div>

        <modal
          v-if="shouldShowHelpInitialSelection"
          title="初期質問リストとは"
          @close="shouldShowHelpInitialSelection = false"
        >
          <p>チャットを開始すぐの画面に、任意の質問候補を最大で５つまで表示できる機能です。</p>
          <p><img :src="initialSelectionsInstruction" class="img-fluid" /></p>
          <p>時期によって質問内容が予想される場合等に設定しておくと効果的です。</p>
        </modal>

        <initial-selection-modal
          v-if="shouldShowInitialSelectionModal"
          @close="shouldShowInitialSelectionModal = false"
        />
      </div>

      <div
        class="container pt-4"
        v-if="similarQuestionAnswers.length > 0"
      >
        <div class="row justify-content-md-center">
          <div class="col-md-6">
            <question-options
              title="こちらの質問ではありませんか？"
              :items="similarQuestionAnswers"
              @select="handleSimilarQuestionAnswerSelect"
            />
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<style scoped lang="scss">
@import './css/gradient';

.speaker-info {
  margin-bottom: 12px;
  display: flex;
  align-items: center;

  .avatar {
    margin-right: 8px;
    margin-left: -4px;
    width: 48px;
    height: 48px;
    background-color: #ddd;
    border-radius: 50%;
    overflow: hidden;
    flex-shrink: 0;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }

  .text {
    width: 100%;
    font-size: 0.8rem;
    color: #444444;

    time {
      color: #999;
    }
  }

  &.guest {
    text-align: right;
  }
}


.balloon {
  padding: 12px 16px;
  border-radius: 16px;
  background-color: #fff;
  box-shadow: 0 16px 24px -8px rgba(0, 0, 0, .05);
  word-break: break-all;

  &--bot {
    @include blue-gradient;
    color: #fff;
    box-shadow: 0 16px 24px -8px rgba(94,185,255,0.2);
    border-top-left-radius: 0px;

    .link {
      color: #fff !important;
      text-decoration: underline;
    }
  }

  &--guest {
    border-top-right-radius: 0px;
  }
}

.feedback {
  padding: 16px 16px 0 0;
  display: flex;
  justify-content: flex-end;
  align-items: center;

  .desc {
    font-size: 0.8rem;
    color: #999;
  }
  button {
    transition-duration: 0.1s;
    transition-property: transform;
    margin-left: 8px;
    padding: 0;
    border: 0;
    background-color: transparent;
    cursor: pointer;
    outline: none;

    &:hover {
      .material-icons {
        color: #666;
      }
    }

    &:active {
      transform: scale(1.2);
      transform-origin: center;
    }
  }
  .material-icons {
    color: #888;

    &.good.active {
      color: #28a745;
    }
    &.bad.active {
      color: #dc3545;
    }
  }
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 1s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}

.log-container {
  position: relative;
  flex-shrink: 0;

  .popover {
    max-width: none;
    top: 100%;
    left: auto;
    right: 0;

    .arrow {
      margin: 0;
      right: 0;
      transform: translateX(-200%);
    }
  }
}
</style>
