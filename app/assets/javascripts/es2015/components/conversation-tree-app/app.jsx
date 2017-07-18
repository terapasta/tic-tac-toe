import React, { Component, PropTypes } from 'react';
import { findDOMNode } from 'react-dom';
import isEmpty from 'is-empty';

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

import {
  decisionBranchTreePropType,
} from './types';

import getOffset from '../../modules/get-offset';
import * as a from './action-creators';

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
  componentDidMount() {
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
    dispatch(a.setActiveItem({ type, nodeKey, node }));
    dispatch(a.toggleNode({ nodeKey }));
  }

  render() {
    const {
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
            <AddingNode onClick={() => { console.log('add'); }} />
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
          {isEmpty(activeItem.nodeKey) && (
            <p className="text-muted">左のツリーから「＋追加」を押すか編集したいアイテムを選択して下さい</p>
          )}
          {activeItem.type === 'question' && (
            <QuestionForm
              activeItem={activeItem}
              questionsRepo={questionsRepo}
            />
          )}
          {activeItem.type === 'answer' && (
            <AnswerForm
              activeItem={activeItem}
              questionsRepo={questionsRepo}
              decisionBranchesRepo={decisionBranchesRepo}
            />
          )}
          {activeItem.type === 'decisionBranch' && (
            <DecisionBranchForm
              activeItem={activeItem}
              decisionBranchesRepo={decisionBranchesRepo}
            />
          )}
          {activeItem.type === 'decisionBranchAnswer' && (
            <DecisionBranchAnswerForm
              activeItem={activeItem}
              decisionBranchesRepo={decisionBranchesRepo}
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
