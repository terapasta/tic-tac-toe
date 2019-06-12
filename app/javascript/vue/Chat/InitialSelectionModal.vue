<template>
  <modal
    title="初期質問リスト"
    @close="$emit('close')"
  >
    test
  </modal>
</template>

<script>
import { mapActions, mapState } from 'vuex'

import Modal from '../Modal'

export default {
  components: {
    Modal,
  },

  created () {
    this.fetchInitialSelections()
  },

  computed: {
    ...mapState([
      'initialSelections'
    ])
  },

  methods: {
    ...mapActions([
      'fetchInitialSelections',
    ])
  }
}
</script>

<style>

</style>
