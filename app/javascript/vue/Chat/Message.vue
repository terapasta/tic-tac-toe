<script>
import format from 'date-fns/format'
import VueMarkdown from 'vue-markdown'

import AnswerFiles from './AnswerFiles'
import QuestionOptions from './QuestionOptions'

export default {
  components: {
    AnswerFiles,
    QuestionOptions,
    VueMarkdown,
  },

  props: {
    bot: { type: Object },
    isAnimate: { type: Boolean, default: true },
    message: { type: Object, required: true },
  },

  computed: {
    isGuest () {
      return this.speaker === 'guest'
    },

    isBot () {
      return this.speaker === 'bot'
    },

    isGood () {
      return false
    },

    isBad () {
      return false
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
  },

  methods: {
    handleVueMarkdownRendered (outHtml) {
    },

    handleDecisionBranchSelect (decisionBranch) {
      this.$emit('select-decision-branch', decisionBranch)
    },

    handleSimilarQuestionAnswerSelect (similarQuestionAnswer) {
      this.$emit('select-question', similarQuestionAnswer.question)
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
              <button>
                <i class="material-icons good" :class="{ active: isGood }">thumb_up</i>
              </button>
              <button>
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
</style>
