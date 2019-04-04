<template>
  <div class="question-options">
    <h6>{{title}}</h6>
    <div class="list-group">
      <a
        href="#"
        class="list-group-item list-group-item-action"
        v-for="(item, i) in items"
        :key="i"
        @click="$emit('select', item, $event)"
      >
        {{item.body}}
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: { type: String, required: true },
    items: { type: Array, required: true },
  }
}
</script>

<style lang="scss" scoped>
h6 {
  color: #999;
  font-size: 0.8rem;
}

a.list-group-item-action {
  color: #5eb9ff;

  &:hover {
    color: #5eb9ff;
  }
}
</style>
