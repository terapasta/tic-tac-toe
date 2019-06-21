<template>
  <div class="question-options">
    <h6>{{title}}</h6>
    <div class="list-group">
      <template v-for="(item, i) in items">
        <div
          href="#"
          class="list-group-item"
          :key="i"
        >
          <button @click="$emit('select', item, $event)">
            {{item.body}}
          </button>
        </div>
      </template>
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

.list-group-item {
  position: relative;
  padding: 0;

  button {
    display: block;
    padding: 0.75rem 1.25rem;
    margin: 0;
    border: 0;
    width: 100%;
    text-align: left;
    border-radius: 0.25rem;
    color: #5eb9ff;
    background-color: #fff;

    &:hover {
      color: #5eb9ff;
      background-color: #f5f5f5;
    }
  }
}

.right-buttons {
  position: absolute;
  left: 100%;
  top: 50%;
  transform: translateY(-50%);

  button {
    padding-top: 0;
    padding-bottom: 0;
    height: 16px;
    display: flex;
    flex-direction: column;
    background-color: transparent;

    &:hover {
      text-decoration: none;
      background-color: transparent;
    }

    .material-icons {
      font-size: inherit;
    }
  }
}
</style>
