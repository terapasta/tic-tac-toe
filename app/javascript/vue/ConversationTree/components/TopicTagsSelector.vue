<script>
import { mapState, mapActions } from 'vuex'
import isEmpty from 'is-empty'
import Multiselect from 'vue-multiselect'
import 'vue-multiselect/dist/vue-multiselect.min.css'
import { values, includes } from 'lodash'

export default {
  components: {
    Multiselect
  },

  data: () => ({
    selectedTopicTags: []
  }),

  watch: {
    // NOTE stateから更新される
    selectedTopicTagIds (val) {
      this.selectedTopicTags = this.topicTags.filter(it => includes(val, it.id))
    }
  },

  computed: {
    ...mapState([
      'topicTagsRepo',
      'selectedTopicTagIds'
    ]),

    topicTags () {
      return values(this.topicTagsRepo)
    }
  },

  methods: {
    ...mapActions([
      'filterQuestionAnswerByTopicTags',
      'clearTopicTagFilter'
    ]),

    makeTopicTagLabel (option) {
      return option.name
    },

    handleMultiselectSelect (selected) {
      const selectedTags = this.selectedTopicTags.concat([selected])
      this.handleSelectedTags(selectedTags)
    },

    handleMultiselectRemove (removed) {
      const selectedTags = this.selectedTopicTags.filter(it => it !== removed.id)
      this.handleSelectedTags(selectedTags)
    },

    handleSelectedTags (selectedTags) {
      const topicTagIds = selectedTags.map(it => it.id)
      if (topicTagIds.length > 0) {
        this.filterQuestionAnswerByTopicTags({ topicTagIds })
      } else {
        this.clearTopicTagFilter()
      }
    }
  }
}
</script>

<template>
  <multiselect
    v-model="selectedTopicTags"
    :options="topicTags"
    :multiple="true"
    :custom-label="makeTopicTagLabel"
    :show-labels="false"
    placeholder="トピックタグで絞込み"
    @select="handleMultiselectSelect"
    @remove="handleMultiselectRemove"
  />
</template>

<style>
.multiselect {
  margin-bottom: 8px;
  margin-left: 16px;
  width: calc(30% - 52px) !important;
}
.multiselect__content-wrapper {
  z-index: 100 !important;
}
.multiselect__tags {
  border-color: #ced4da !important;
  border-radius: 0.2rem !important;
}
.multiselect__tag,
.multiselect__option--highlight {
  background-color: #17a2b8 !important;
}
.multiselect__tag-icon:hover {
  background-color: darken(#17a2b8, 5%) !important;
}
</style>