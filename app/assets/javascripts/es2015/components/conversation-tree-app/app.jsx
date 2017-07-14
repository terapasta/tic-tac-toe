import React, { Component, PropTypes } from 'react';
import { findDOMNode } from 'react-dom';

import getOffset from '../../modules/get-offset';
import MasterDetailPanel, { Master, Detail } from '../master-detail-panel';

import * as a from './action-creators';
import { decisionBranchTreePropType } from './helpers';
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

  render() {
    const {
      dispatch,
      questionsTree,
      questionsRepo,
      decisionBranchesRepo,
      openedNodes,
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
                  onClickQuestionNode={(id) => dispatch(a.toggleQuestionNode({ id }))}
                  onClickAnswerNode={(id) => dispatch(a.toggleAnswerNode({ id }))}
                  onClickDecisionBranchNode={(id) => dispatch(a.toggleDecisionBranchNode({ id }))}
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

ConversationTree.componentName = "ConversationTree";

ConversationTree.propTypes = {
  botId: PropTypes.number.isRequired,
  questionsTree: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number.isRequired,
    decisionBranches: decisionBranchTreePropType,
  })),
};

export default ConversationTree;
