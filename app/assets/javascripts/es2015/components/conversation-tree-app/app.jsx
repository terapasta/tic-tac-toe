import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { findDOMNode } from 'react-dom';

import {
  decisionBranchTreePropType,
  questionNodeKey,
  answerNodeKey,
  decisionBranchNodeKey,
  decisionBranchAnswerNodeKey,
} from './helpers';

import getOffset from '../../modules/get-offset';
import * as a from './action-creators';

import MasterDetailPanel, { Master, Detail } from '../master-detail-panel';
import Tree from './components/tree';
import QuestionNode from './components/question-node';

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

  onClickNode(nodeKey) {
    const { dispatch } = this.props;
    const payload = { nodeKey };
    dispatch(a.setActiveItem(payload));
    dispatch(a.toggleNode(payload));
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
            {questionsTree.map((node) => {
              return (
                <QuestionNode key={node.id}
                  node={node}
                  questionsRepo={questionsRepo}
                  decisionBranchesRepo={decisionBranchesRepo}
                  openedNodes={openedNodes}
                  activeItem={activeItem}
                  onClickQuestionNode={id => this.onClickNode(questionNodeKey(id))}
                  onClickAnswerNode={id => this.onClickNode(answerNodeKey(id))}
                  onClickDecisionBranchNode={id => this.onClickNode(decisionBranchNodeKey(id))}
                  onClickDecisionBranchAnswerNode={id => this.onClickNode(decisionBranchAnswerNodeKey(id))}
                />
              );
            })}
          </Tree>
        </Master>
        <Detail>
          detail
        </Detail>
      </MasterDetailPanel>
    );
  }
}

ConversationTree.componentName = 'ConversationTree';

ConversationTree.propTypes = {
  questionsTree: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number.isRequired,
    decisionBranches: decisionBranchTreePropType,
  })).isRequired,
  questionsRepo: PropTypes.shape({
    [PropTypes.number]: PropTypes.shape({
      question: PropTypes.string,
      answer: PropTypes.string,
    }),
  }).isRequired,
  decisionBranchesRepo: PropTypes.shape({
    [PropTypes.number]: PropTypes.shape({
      body: PropTypes.string,
      answer: PropTypes.string,
    }),
  }).isRequired,
  openedNodes: PropTypes.arrayOf(PropTypes.string).isRequired,
  activeItem: PropTypes.shape({
    nodeKey: PropTypes.string,
  }).isRequired,
};

export default ConversationTree;
