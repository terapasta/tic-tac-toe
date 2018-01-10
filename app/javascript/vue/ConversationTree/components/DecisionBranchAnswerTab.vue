<script>
import AnswerIcon from './AnswerIcon'

export const TabType = {
  Input: 'input',
  Select: 'select'
}

export default {
  components: {
    AnswerIcon
  },

  props: {
    tabType: { type: String, default: TabType.Input }
  },

  data: () => ({
    currentTab: TabType.Input
  }),

  mounted () {
    this.currentTab = this.tabType
  },

  computed: {
    TabType () { return TabType }
  },

  methods: {
    handleInputTabClick () {
      this.currentTab = TabType.Input
    },

    handleSelectTabClick () {
      this.currentTab = TabType.Select
    }
  }
}
</script>

<template>
  <div>
    <div class="d-flex mb-2">
      <label class="mb-0" style="width:80px; padding-top: 8px;"><answer-icon />&nbsp;回答</label>
      <ul class="nav nav-tabs" style="width:100%;">
        <li class="nav-item">
          <a
            @click.prevent="handleInputTabClick"
            :class="`nav-link ${this.currentTab === TabType.Input ? 'active' : ''}`"
            href="#"
          >入力する</a>
        </li>
        <li class="nav-item">
          <a
            @click.prevent="handleSelectTabClick"
            :class="`nav-link ${this.currentTab === TabType.Select ? 'active' : ''}`"
            href="#"
          >選択する</a>
        </li>
      </ul>
    </div>
    <slot v-if="currentTab === TabType.Input" name="input" />
    <slot v-if="currentTab === TabType.Select" name="select" />
  </div>
</template>

<style scoped lang="scss">
</style>