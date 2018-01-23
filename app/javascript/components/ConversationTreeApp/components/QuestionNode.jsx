import React, { Component } from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import isEmpty from 'is-empty'
import includes from 'lodash/includes'

import {
  questionNodeKey,
} from '../helpers'

import {
  questionNodeType,
  questionsRepoType,
  decisionBranchesRepoType,
  activeItemType,
  openedNodesType,
} from '../types'

import Tree from './Tree'
import AnswerNode from './AnswerNode'

class QuestionNode extends Component {
  constructor(props) {
    super(props)
    this.state = {}
    this.onClickQuestionNode = this.onClickQuestionNode.bind(this)
  }

  onClickQuestionNode(e) {
    e.stopPropagation()
    const { node, onClickQuestionNode } = this.props
    onClickQuestionNode(node)
  }

  render() {
    const {
      node,
      questionsRepo,
      decisionBranchesRepo,
      openedNodes,
      activeItem,
      onClickAnswerNode,
      onClickDecisionBranchNode,
      onClickDecisionBranchAnswerNode,
    } = this.props

    const { question, answer } = questionsRepo[node.id]
    const isOpened = includes(openedNodes, questionNodeKey(node.id))
    const itemClassName = classnames('tree__item', {
      'tree__item--no-children': isEmpty(answer),
      'tree__item--opened': isOpened,
      'active': activeItem.nodeKey === questionNodeKey(node.id),
    })

    return (
      <li
        className="tree__node"
        onClick={this.onClickQuestionNode}
        id={`question-${node.id}`}
      >
        <div className={itemClassName}>
          <div className="tree__item-body">
            <i className="material-icons" title="質問">comment</i>
            {question}
          </div>
        </div>
        {!isEmpty(answer) && (
          <Tree isOpened={isOpened}>
            <AnswerNode
              node={node}
              questionsRepo={questionsRepo}
              decisionBranchesRepo={decisionBranchesRepo}
              openedNodes={openedNodes}
              activeItem={activeItem}
              onClickAnswerNode={onClickAnswerNode}
              onClickDecisionBranchNode={onClickDecisionBranchNode}
              onClickDecisionBranchAnswerNode={onClickDecisionBranchAnswerNode}
            />
          </Tree>
        )}
      </li>
    )
  }
}

QuestionNode.propTypes = {
  node: questionNodeType.isRequired,
  questionsRepo: questionsRepoType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
  openedNodes: openedNodesType.isRequired,
  activeItem: activeItemType.isRequired,

  onClickQuestionNode: PropTypes.func.isRequired,
  onClickAnswerNode: PropTypes.func.isRequired,
  onClickDecisionBranchNode: PropTypes.func.isRequired,
  onClickDecisionBranchAnswerNode: PropTypes.func.isRequired,
}

QuestionNode.defaultProps = {
}

export default QuestionNode