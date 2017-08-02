import React, { Component, PropTypes } from 'react';
import { findDOMNode } from 'react-dom';
import isEmpty from 'is-empty';
import bindAll from 'lodash/bindAll';

import {
  questionsTreeType,
  questionsRepoType,
  decisionBranchesRepoType,
  openedNodesType,
  activeItemType,
} from './types';

import {
  questionNodeKey,
  answerNodeKey,
  decisionBranchNodeKey,
  decisionBranchAnswerNodeKey,
} from './helpers';

import getOffset from '../../modules/get-offset';
import * as actions from './action-creators';
import * as questionActions from './action-creators/question';
import * as decisionBranchActions from './action-creators/decision-branch';

import MasterDetailPanel, { Master, Detail } from '../master-detail-panel';
import Tree from './components/tree';
import QuestionNode from './components/question-node';
import QuestionForm from './components/question-form';
import AnswerForm from './components/answer-form';
import DecisionBranchForm from './components/decision-branch-form';
import DecisionBranchAnswerForm from './components/decision-branch-answer-form';
import AddingNode from './components/adding-node';

function adjustHeight(targetRef) {
  const targetNode = findDOMNode(targetRef);
  const offset = getOffset(targetNode);
  const winHeight = window.innerHeight;
  const height = winHeight - offset.top - 20;
  targetNode.style.height = `${height}px`;
}

class ConversationTree extends Component {
  constructor(props) {
    super(props);
    bindAll(this, ['handleWindowResize']);
  }

  componentDidMount() {
    adjustHeight(this.refs.masterDetailPanel);
    window.addEventListener('resize', this.handleWindowResize);
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleWindowResize);
  }

  handleWindowResize() {
    adjustHeight(this.refs.masterDetailPanel);
  }

  onClickNode(type, node) {
    const { dispatch } = this.props;
    let nodeKey;
    switch(type) {
      case 'question':
        nodeKey = questionNodeKey(node.id);
        break;
      case 'answer':
        nodeKey = answerNodeKey(node.id);
        break;
      case 'decisionBranch':
        nodeKey = decisionBranchNodeKey(node.id);
        break;
      case 'decisionBranchAnswer':
        nodeKey = decisionBranchAnswerNodeKey(node.id);
        break;
      default: break;
    }
    dispatch(actions.setActiveItem({ type, nodeKey, node }));
    dispatch(actions.toggleNode({ nodeKey }));
  }

  render() {
    const {
      dispatch,
      questionsTree,
      questionsRepo,
      decisionBranchesRepo,
      openedNodes,
      activeItem,
    } = this.props;

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
              onCreate={(question, answer) => dispatch(questionActions.createQuestion(question, answer))}
              onUpdate={(id, question, answer) => dispatch(questionActions.updateQuestion(id, question, answer))}
              onDelete={(id) => dispatch(questionActions.deleteQuestion(id))}
            />
          )}
          {activeItem.type === 'answer' && (
            <AnswerForm
              activeItem={activeItem}
              questionsRepo={questionsRepo}
              decisionBranchesRepo={decisionBranchesRepo}
              onUpdateAnswer={(id, question, answer) => dispatch(questionActions.updateQuestion(id, question, answer))}
              onDeleteAnswer={(id, question) => dispatch(questionActions.deleteAnswer(id, question))}
              onCreateDecisionBranch={(answerId, body) => dispatch(decisionBranchActions.createDecisionBranch(answerId, body))}
              onUpdateDecisionBranch={(answerId, id, body) => dispatch(decisionBranchActions.updateDecisionBranch(answerId, id, body))}
              onDeleteDecisionBranch={(answerId, id) => dispatch(decisionBranchActions.deleteDecisionBranch(answerId, id))}
            />
          )}
          {activeItem.type === 'decisionBranch' && (
            <DecisionBranchForm
              activeItem={activeItem}
              questionsTree={questionsTree}
              decisionBranchesRepo={decisionBranchesRepo}
              onUpdate={(answerId, id, body, answer) => dispatch(decisionBranchActions.updateDecisionBranch(answerId, id, body, answer))}
              onNestedUpdate={(id, body, answer) => dispatch(decisionBranchActions.updateNestedDecisionBranch(id, body, answer))}
              onDelete={(answerId, id) => {
                dispatch(decisionBranchActions.deleteDecisionBranch(answerId, id)).then(() => {
                  dispatch(actions.rejectActiveItem());
                });
              }}
              onNestedDelete={(parentId, id) => dispatch(decisionBranchActions.deleteNestedDecisionBranch(parentId, id))}
            />
          )}
          {activeItem.type === 'decisionBranchAnswer' && (
            <DecisionBranchAnswerForm
              activeItem={activeItem}
              decisionBranchesRepo={decisionBranchesRepo}
              onUpdateAnswer={(id, body, answer) => dispatch(decisionBranchActions.updateNestedDecisionBranch(id, body, answer))}
              onDeleteAnswer={(id, body) => dispatch(decisionBranchActions.deleteNestedDecisionBranchAnswer(id, body))}
              onCreateDecisionBranch={(dbId, body) => dispatch(decisionBranchActions.createNestedDecisionBracnh(dbId, body))}
              onUpdateDecisionBranch={(id, body) => dispatch(decisionBranchActions.updateNestedDecisionBranch(id, body))}
              onDeleteDecisionBranch={(parentId, id) => dispatch(decisionBranchActions.deleteNestedDecisionBranch(parentId, id))}
            />
          )}
        </Detail>
      </MasterDetailPanel>
    );
  }
}

ConversationTree.componentName = 'ConversationTree';

ConversationTree.propTypes = {
  questionsTree: questionsTreeType.isRequired,
  questionsRepo: questionsRepoType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
  openedNodes: openedNodesType.isRequired,
  activeItem: activeItemType.isRequired,
};

export default ConversationTree;
