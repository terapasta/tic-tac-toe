import includes from 'lodash/includes'
import classnames from 'classnames'

import { isDescendantDecisionBranch } from '../helpers'

export default {
  computed: {
    itemClassName () {
      return classnames('tree__item', {
        'tree__item--no-children': !this.hasChildren,
        'tree__item--opened': this.isOpened,
        'active': this.isActive
      })
    },

    isActive () {
      const { name, params: { id } } = this.$route
      const intId = window.parseInt(id)
      return name === this.routeName && intId === this.node.id
    },

    nodeId () {
      return `${this.routeName}-${this.node.id}`
    },

    isStoredOpenedNodes () {
      return includes(this.openedNodes, this.nodeId)
    },

    currentPageIsChild () {
      const { name, params: { id } } = this.$route
      const intId = window.parseInt(id)
      const descendants = [
        'DecisionBranch',
        'DecisionBranchAnswer'
      ]

      switch (this.routeName) {
        case 'Question':
          if (name === 'Answer' && intId === this.node.id) { return true }
          break
        case 'DecisionBranch':
          if (name === 'DecisionBranchAnswer' && intId === this.node.id) { return true }
          break
        case 'Answer':
        case 'DecisionBranchAnswer':
          break
        default:
          break
      }
      return includes(descendants, name) && isDescendantDecisionBranch(this.node, intId)
    },

    currentPageIsOwnAnswer () {
      const { name, params: { id } } = this.$route
      const intId = window.parseInt(id)
      return name === 'Answer' && intId === this.node.id
    },

    childTreeStyle () {
      return {
        display: this.isOpened ? 'block' : 'none'
      }
    }
  },

  methods: {
    callOpenNodeIfNeeded (route) {
      if (this.currentPageIsChild) {
        this.openNode({ nodeId: this.nodeId })
      }
    },

    handleClick () {
      if (!this.hasChildren) { return }
      const params = { nodeId: this.nodeId }
      if (this.isStoredOpenedNodes) {
        this.closeNode(params)
      } else {
        this.openNode(params)
      }
    }
  }
}