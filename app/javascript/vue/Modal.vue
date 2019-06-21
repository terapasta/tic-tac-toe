<template>
  <div>
    <div class="modal-backdrop fade show" />
    <div
      class="modal fade show"
      tabindex="-1"
      role="dialog"
      style="display:block"
      @click.stop.prevent="handleOutsideClick"
    >
      <div class="modal-dialog" role="document">
        <div class="modal-content">

          <div class="modal-header">
            <h5
              v-if="title"
              class="modal-title"
            >
              {{title}}
            </h5>
            <button
              type="button"
              class="close"
              aria-label="Close"
              @click.stop.prevent="handleCloseClick"
            >
              <span aria-hidden="true">&times;</span>
            </button>
          </div>

          <div class="modal-body">
            <slot name="default" />
          </div>

          <div
            v-if="$slots.footer"
            class="modal-footer"
          >
            <slot name="footer" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: { type: String },
  },

  methods: {
    handleCloseClick () {
      this.$emit('close')
    },

    handleOutsideClick () {
      this.$emit('close')
    }
  }
}
</script>

<style>

</style>
