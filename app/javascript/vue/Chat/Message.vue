<script>
export default {
  props: {
    speaker: { type: String, required: true },
    body: { type: String, required: true },
    isAnimate: { type: Boolean, default: true },
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
      <div v-if="isBot">
        <div class="avatar"></div>
      </div>
      <div
        :class="balloonClass"
      >
        {{body}}
      </div>
    </div>
  </transition>
</template>

<style scoped lang="scss">
.avatar {
  margin-bottom: 12px;
  margin-left: -4px;
  width: 48px;
  height: 48px;
  background-color: #ddd;
  border-radius: 50%;
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

.fade-enter-active, .fade-leave-active {
  transition: opacity 1s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
