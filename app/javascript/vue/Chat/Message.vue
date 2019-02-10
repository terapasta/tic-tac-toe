<script>
import format from 'date-fns/format'

export default {
  props: {
    bot: { type: Object },
    speaker: { type: String, required: true },
    body: { type: String, required: true },
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
    <div
      :class="wrapperClass"
    >
      <div v-if="isBot" class="speaker-info bot">
        <div class="avatar">
          <a :href="bot.image.url" target="_blank">
            <img :src="bot.image.thumb.url" />
          </a>
        </div>
        <div class="text">
          <span>{{bot.name}}</span>
          <time>{{formattedCreatedAt}}</time>
        </div>
      </div>

      <div v-if="isGuest" class="speaker-info guest">
        <div class="text">
          <time>{{formattedCreatedAt}}</time>
        </div>
      </div>

      <div
        :class="balloonClass"
      >
        {{body}}
      </div>

      <div v-if="isBot" class="feedback">
        <div class="desc">この回答を評価してください</div>
        <button>
          <i class="material-icons good" :class="{ active: true }">thumb_up</i>
        </button>
        <button>
          <i class="material-icons bad" :class="{ active: true }">thumb_down</i>
        </button>
      </div>
    </div>
  </transition>
</template>

<style scoped lang="scss">
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
    background: rgba(94,185,255,1);
    background: -moz-linear-gradient(-45deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    background: -webkit-gradient(left top, right bottom, color-stop(0%, rgba(94,185,255,1)), color-stop(100%, rgba(39,96,194,1)));
    background: -webkit-linear-gradient(-45deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    background: -o-linear-gradient(-45deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    background: -ms-linear-gradient(-45deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    background: linear-gradient(135deg, rgba(94,185,255,1) 0%, rgba(39,96,194,1) 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#5eb9ff', endColorstr='#2760c2', GradientType=1 );
    color: #fff;
    box-shadow: 0 16px 24px -8px rgba(94,185,255,0.2);
    border-top-left-radius: 0px;
  }

  &--guest {
    border-top-right-radius: 0px;
  }
}

.feedback {
  padding: 8px 16px 0 0;
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
