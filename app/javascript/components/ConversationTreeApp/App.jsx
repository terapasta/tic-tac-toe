import React, { Component } from 'react'
import { findDOMNode } from 'react-dom'
import isEmpty from 'is-empty'
import bindAll from 'lodash/bindAll'
import toastr from 'toastr'

import {
  questionsTreeType,
  questionsRepoType,
  decisionBranchesRepoType,
  openedNodesType,
  activeItemType
} from './types'

import {
  questionNodeKey,
  answerNodeKey,
  decisionBranchNodeKey,
  decisionBranchAnswerNodeKey
} from './helpers'

import getOffset from '../../helpers/getOffset'
import * as actions from './actionCreators'
import * as questionActions from './actionCreators/question'
import * as decisionBranchActions from './actionCreators/decisionBranch'

import MasterDetailPanel, { Master, Detail } from '../MasterDetailPanel'
import Tree from './components/Tree'
import QuestionNode from './components/QuestionNode'
import QuestionForm from './components/QuestionForm'
import AnswerForm from './components/AnswerForm'
import DecisionBranchForm from './components/DecisionBranchForm'
import DecisionBranchAnswerForm from './components/DecisionBranchAnswerForm'
import AddingNode from './components/AddingNode'

function adjustHeight(targetRef) {
  const targetNode = findDOMNode(targetRef)
  const offset = getOffset(targetNode)
  const winHeight = window.innerHeight
  const height = winHeight - offset.top - 20
  targetNode.style.height = `${height}px`
}

class ConversationTree extends Component {
  constructor(props) {
    super(props)
    bindAll(this, ['handleWindowResize'])
  }

  componentDidMount() {
    adjustHeight(this.refs.masterDetailPanel)
    window.addEventListener('resize', this.handleWindowResize)
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleWindowResize)
  }

  handleWindowResize() {
    adjustHeight(this.refs.masterDetailPanel)
  }

  onClickNode(type, node) {
    const { dispatch } = this.props
    let nodeKey
    switch(type) {
      case 'question':
        nodeKey = questionNodeKey(node.id)
        break
      case 'answer':
        nodeKey = answerNodeKey(node.id)
        break
      case 'decisionBranch':
        nodeKey = decisionBranchNodeKey(node.id)
        break
      case 'decisionBranchAnswer':
        nodeKey = decisionBranchAnswerNodeKey(node.id)
        break
      default: break
    }
    dispatch(actions.setActiveItem({ type, nodeKey, node }))
    dispatch(actions.toggleNode({ nodeKey }))
  }

  render() {
    const {
      dispatch,
      questionsTree,
      questionsRepo,
      decisionBranchesRepo,
      openedNodes,
      activeItem,
    } = this.props

    return (
      <MasterDetailPanel title="会話ツリー" ref="masterDetailPanel">
        <Master>
          <Tree>
            <AddingNode
              activeItem={activeItem}
              onClick={() => dispatch(actions.setActiveItem({ type: 'question', nodeKey: null, node: null }))}
            />
            {questionsTree.map((node) => {
              return (
                <QuestionNode key={node.id}
                  node={node}
                  questionsRepo={questionsRepo}
                  decisionBranchesRepo={decisionBranchesRepo}
                  openedNodes={openedNodes}
                  activeItem={activeItem}
                  onClickQuestionNode={nd => this.onClickNode('question', nd)}
                  onClickAnswerNode={nd => this.onClickNode('answer', nd)}
                  onClickDecisionBranchNode={nd => this.onClickNode('decisionBranch', nd)}
                  onClickDecisionBranchAnswerNode={nd => this.onClickNode('decisionBranchAnswer', nd)}
                />
              );
            })}
          </Tree>
        </Master>
        <Detail>
          {isEmpty(activeItem.type) && (
            <p className="text-muted">左のツリーから「＋追加」を押すか編集したいアイテムを選択して下さい</p>
          )}
          {activeItem.type === 'question' && (
            <QuestionForm
              activeItem={activeItem}
              questionsRepo={questionsRepo}
              onCreate={(question, answer) => {
                dispatch(questionActions.createQuestion(question, answer)).then(() => {
                  toastr.success('Q&Aを追加しました');
                });
              }}
              onUpdate={(id, question, answer) => {
                dispatch(questionActions.updateQuestion(id, question, answer)).then(() => {
                  toastr.success('Q&Aを更新しました');
                });
              }}
              onDelete={(id) => {
                dispatch(questionActions.deleteQuestion(id)).then(() => {
                  toastr.success('Q&Aを削除しました');
                });
              }}
            />
          )}
          {activeItem.type === 'answer' && (
            <AnswerForm
              activeItem={activeItem}
              questionsRepo={questionsRepo}
              decisionBranchesRepo={decisionBranchesRepo}
              onUpdateAnswer={(id, question, answer) => {
                dispatch(questionActions.updateQuestion(id, question, answer)).then(() => {
                  toastr.success('回答を更新しました');
                });
              }}
              onDeleteAnswer={(id, question) => {
                dispatch(questionActions.deleteAnswer(id, question)).then(() => {
                  toastr.success('回答を削除しました');
                });
              }}
              onCreateDecisionBranch={(answerId, body) => dispatch(decisionBranchActions.createDecisionBranch(answerId, body))}
              onUpdateDecisionBranch={(answerId, id, body) => dispatch(decisionBranchActions.updateDecisionBranch(answerId, id, body))}
              onDeleteDecisionBranch={(answerId, id) => dispatch(decisionBranchActions.deleteDecisionBranch(answerId, id))}
            />
          )}
          {activeItem.type === 'decisionBranch' && (
            <DecisionBranchForm
              activeItem={activeItem}
              questionsTree={questionsTree}
              questionsRepo={questionsRepo}
              decisionBranchesRepo={decisionBranchesRepo}
              onUpdate={(answerId, id, body, answer) => {
                return dispatch(decisionBranchActions.updateDecisionBranch(answerId, id, body, answer)).then(() => {
                  toastr.success('選択肢を更新しました');
                });
              }}
              onNestedUpdate={(id, body, answer) => dispatch(decisionBranchActions.updateNestedDecisionBranch(id, body, answer))}
              onDelete={(answerId, id) => {
                dispatch(decisionBranchActions.deleteDecisionBranch(answerId, id)).then(() => {
                  dispatch(actions.rejectActiveItem());
                  toastr.success('選択肢を削除しました');
                });
              }}
              onNestedDelete={(parentId, id) => dispatch(decisionBranchActions.deleteNestedDecisionBranch(parentId, id))}
            />
          )}
          {activeItem.type === 'decisionBranchAnswer' && (
            <DecisionBranchAnswerForm
              activeItem={activeItem}
              decisionBranchesRepo={decisionBranchesRepo}
              onUpdateAnswer={(id, body, answer) => {
                dispatch(decisionBranchActions.updateNestedDecisionBranch(id, body, answer)).then(() => {
                  toastr.success('回答を更新しました');
                });
              }}
              onDeleteAnswer={(id, body) => {
                dispatch(decisionBranchActions.deleteNestedDecisionBranchAnswer(id, body)).then(() => {
                  toastr.success('回答を削除しました');
                });
              }}
              onCreateDecisionBranch={(dbId, body) => dispatch(decisionBranchActions.createNestedDecisionBracnh(dbId, body))}
              onUpdateDecisionBranch={(id, body) => dispatch(decisionBranchActions.updateNestedDecisionBranch(id, body))}
              onDeleteDecisionBranch={(parentId, id) => dispatch(decisionBranchActions.deleteNestedDecisionBranch(parentId, id))}
            />
          )}
        </Detail>
      </MasterDetailPanel>
    )
  }
}

ConversationTree.componentName = 'ConversationTree'

ConversationTree.propTypes = {
  questionsTree: questionsTreeType.isRequired,
  questionsRepo: questionsRepoType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
  openedNodes: openedNodesType.isRequired,
  activeItem: activeItemType.isRequired
}

export default ConversationTree
