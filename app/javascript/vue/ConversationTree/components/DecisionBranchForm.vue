<script>
import { mapState, mapActions } from 'vuex'
import toastr from 'toastr'
import isEmpty from 'is-empty'
import isNaN from 'lodash/isNaN'
import range from 'lodash/range'
import includes from 'lodash/includes'
import last from 'lodash/last'
import compact from 'lodash/compact'
import get from 'lodash/get'
import reduce from 'lodash/reduce'

import DecisionBranchFormMixin from '../mixins/DecisionBranchForm'

import AnswerIcon from './AnswerIcon'
import DecisionBranchIcon from './DecisionBranchIcon'
import AnswerTab, { TabType } from './DecisionBranchAnswerTab'
import SelectableTree from './SelectableTree'
import SearchForm, { Mode as SearchFormMode } from './SearchForm'
import { calcPercentile } from '../helpers'

const getComputedHeight = el => {
  const toInt = val => {
    const int = parseInt(val.replace(/px/, ''))
    return isNaN(int) ? 0 : int
  }
  const style = window.getComputedStyle(el)
  const paddingTop = toInt(style.paddingTop)
  const paddingBottom = toInt(style.paddingBottom)
  const marginTop = toInt(style.marginTop)
  const marginBottom = toInt(style.marginBottom)
  return el.offsetHeight + paddingTop + paddingBottom + marginTop + marginBottom
}

const Direction = {
  Up: 'up',
  Down: 'down'
}

export default {
  mixins: [DecisionBranchFormMixin],

  components: {
    AnswerIcon,
    DecisionBranchIcon,
    AnswerTab,
    SelectableTree,
    SearchForm
  },

  data: () => ({
    questionAnswerId: null,
    decisionBranch: {},
    heightCheckTimerId: null,
    answerFormGroupHeight: null,
    currentTab: null,
    showingIndecies: range(0, 20),
    searchFormMode: SearchFormMode.Selectable
  }),

  mounted () {
    this.setDecisionBranch()
    this.currentTab = isEmpty(this.nodeData.answerLink) ? TabType.Input : TabType.Select
    this.heightCheckTimerId = setInterval(() => {
      this.calcAndSetAnswerFormGroupHeight()
    }, 100)
  },

  beforeDestroy () {
    clearInterval(this.heightCheckTimerId)
  },

  watch: {
    $route () {
      this.setDecisionBranch()
    },

    filteredQuestionsSelectableTree () {
      this.showingIndecies = range(0, 20)
    }
  },

  computed: {
    ...mapState([
      'questionsRepo',
      'decisionBranchesRepo',
      'questionsTree',
      'filteredQuestionsSelectableTree'
    ]),

    currentId () {
      return window.parseInt(this.$route.params.id)
    },

    nodeData () {
      return this.decisionBranchesRepo[this.currentId]
    },

    decisionBranchId () {
      return this.currentId
    },

    tabType () {
      return isEmpty(this.nodeData.answerLink) ? TabType.Input : TabType.Select
    },

    answerFormGroupStyle () {
      if (this.answerFormGroupHeight === null) {
        return {}
      } else {
        return {
          height: this.answerFormGroupHeight + 'px',
          overflowY: 'auto'
        }
      }
    },

    filteredQuestionsTree () {
      return this.filteredQuestionsSelectableTree.filter((_, i) => includes(this.showingIndecies, i))
    }
  },

  methods: {
    ...mapActions([
      'updateDecisionBranch',
      'deleteDecisionBranch',
      'deselectAnswerLink'
    ]),

    setDecisionBranch () {
      this.decisionBranch = this.decisionBranchesRepo[this.currentId]
    },

    handleSaveButtonClick () {
      const { id, body, answer } = this.decisionBranch
      let promises = []

      if (!isEmpty(answer)) {
        promises.push(this.deselectAnswerLink({ decisionBranchId: this.currentId }))
      }

      promises.push(this.updateDecisionBranch({
        decisionBranchId: id,
        body,
        answer
      }))

      Promise.all(promises)
        .then(() => {
          toastr.success('選択肢を更新しました')
          this.isEditing = false
        }).catch(() => {
          toastr.error('選択肢を更新できませんでした', 'エラー')
        })
    },

    calcAnswerFormGroupHeight () {
      const parentYPadding = 32
      const marginBottom = 16
      const rawMaxHeight = window.getComputedStyle(this.$el.parentNode).maxHeight
      if (rawMaxHeight === 'none') { return }
      const maxHeight = window.parseInt(rawMaxHeight.replace(/px/, ''))
      const { bodyFormGroup, actionFormGroup } = this.$refs
      const bodyHeight = getComputedHeight(bodyFormGroup)
      const actionHeight = getComputedHeight(actionFormGroup)
      const answerHeight = maxHeight - bodyHeight - actionHeight - parentYPadding - marginBottom
      return answerHeight
    },

    calcAndSetAnswerFormGroupHeight () {
       switch (this.currentTab) {
        case TabType.Input:
          this.answerFormGroupHeight = null
          break
        case TabType.Select:
          this.answerFormGroupHeight = this.calcAnswerFormGroupHeight()
          break
      }
    },

    handleAnswerTabChange (tab) {
      this.currentTab = tab
    },

    handleAnswerFormGroupWheel (e) {
      if (this.currentTab !== TabType.Select) { return }
      const { offsetHeight, scrollHeight, scrollTop } = this.$refs.answerFormGroup
      let direction
      if (isEmpty(e.deltaY)) {
        direction = e.wheelDelta < 0 ? Direction.Down : Direction.Up
      } else {
        direction = e.deltaY > 0 ? Direction.Down : Direction.Up
      }
      const percentile = calcPercentile(offsetHeight, scrollHeight, scrollTop)

      if (direction === Direction.Up && percentile < 0.3) {
        if (this.showingIndecies[0] !== 0) {
          const targetIndex = this.showingIndecies[0] - 1
          this.showingIndecies = [targetIndex].concat(this.showingIndecies)

          const hiddenComponents = this.$refs.tree.$children.filter((child, i) => {
            const rect = child.$el.getBoundingClientRect()
            const { top, height } = this.$refs.answerFormGroup.getBoundingClientRect()
            return rect.top > top + height
          })
          const hiddenIds = compact(hiddenComponents.map(it => get(it, 'node.id', null)))
          const hiddableIndecies = reduce(this.filteredQuestionsSelectableTree, (acc, node, i) => {
            if (includes(hiddenIds, node.id)) { acc.push(i) }
            return acc
          }, [])
          this.showingIndecies = this.showingIndecies.filter(i => !includes(hiddableIndecies, i))
        }
      }

      if (direction === Direction.Down && percentile > 0.8) {
        if (last(this.showingIndecies) < this.filteredQuestionsSelectableTree.length - 1) {
          this.showingIndecies = this.showingIndecies.concat([last(this.showingIndecies) + 1])

          const hiddenComponents = this.$refs.tree.$children.filter((child, i) => {
            const { top, height } = child.$el.getBoundingClientRect()
            return top + height < this.$refs.answerFormGroup.getBoundingClientRect().top
          })
          const hiddenIds = compact(hiddenComponents.map(it => get(it, 'node.id', null)))
          const hiddableIndecies = reduce(this.filteredQuestionsSelectableTree, (acc, node, i) => {
            if (includes(hiddenIds, node.id)) { acc.push(i) }
            return acc
          }, [])
          this.showingIndecies = this.showingIndecies.filter(i => !includes(hiddableIndecies, i))
        }
      }
    }
  }
}
</script>

<template>
  <div class="decisionBranchForm">
    <div class="form-group" ref="bodyFormGroup">
      <label><decision-branch-icon />&nbsp;現在の選択肢</label>
      <input
        type="text"
        class="form-control"
        v-model="decisionBranch.body"
      />
    </div>
    <div
      class="form-group test"
      ref="answerFormGroup"
      :style="answerFormGroupStyle"
      @wheel="handleAnswerFormGroupWheel"
    >
      <answer-tab :tabType="tabType" @changeTab="handleAnswerTabChange">
        <textarea
          class="form-control"
          rows="3"
          v-model="decisionBranch.answer"
          slot="input"
        ></textarea>
        <div slot="select">
          <p>この選択肢から別のQ&Aツリーの回答にリンクさせることができます</p>
          <search-form
            :mode="searchFormMode"
          />
          <selectable-tree
            :data="decisionBranch"
            :filtered-questions-tree="filteredQuestionsTree"
            ref="tree"
          />
        </div>
      </answer-tab>
    </div>
    <div class="text-right" ref="actionFormGroup">
      <button
        class="btn btn-success"
        id="save-answer-button"
        @click.prevent="handleSaveButtonClick"
      >保存</button>
      &nbsp;&nbsp;
      <button
        class="btn btn-link"
        id="delete-answer-button"
        @click.prevent="handleDeleteButtonClick"
      ><span class="text-danger">削除</span></button>
    </div>
</div>
</template>