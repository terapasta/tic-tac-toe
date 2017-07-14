import React, { Component, PropTypes } from 'react';
import classnames from 'classnames';
import includes from 'lodash/includes';
import isEmpty from 'is-empty';

import { decisionBranchTreePropType, openedNodesType } from '../helpers';
import Tree from './tree';
import DecisionBranchNodes from './decision-branch-nodes';

class AnswerNode extends Component {
  constructor(props) {
    super(props);
    this.state = {};
    this.onClickAnswerNode = this.onClickAnswerNode.bind(this);
  }

  onClickAnswerNode(e) {
    e.stopPropagation();
    const { node, onClickAnswerNode } = this.props;
    if (isEmpty(node.decisionBranches)) { return; }
    onClickAnswerNode(node.id);
  }

  render() {
    const {
      node,
      questionsRepo,
      decisionBranchesRepo,
      openedNodes,
      onClickDecisionBranchNode,
    } = this.props;

    const { answer } = questionsRepo[node.id];
    const isOpened = includes(openedNodes.answerIds, node.id);
    const itemClassName = classnames('tree__item', {
      'tree__item--no-children': isEmpty(node.decisionBranches),
      'tree__item--opened': isOpened,
      'active': false,
    });

    return (
      <li
        className="tree__node"
        onClick={this.onClickAnswerNode}
        id={`answer-${node.id}`}
      >
        <div className={itemClassName}>
          <div className="tree__item-body">
            <i className="material-icons" title="質問">chat_bubble_outline</i>
            {answer}
          </div>
        </div>
        {!isEmpty(node.decisionBranches) && (
          <Tree isOpened={isOpened}>
            <DecisionBranchNodes
              nodes={node.decisionBranches}
              decisionBranchesRepo={decisionBranchesRepo}
              openedNodes={openedNodes}
              onClickDecisionBranchNode={onClickDecisionBranchNode}
            />
          </Tree>
        )}
      </li>
    );
  }
}

AnswerNode.propTypes = {
  node: PropTypes.shape({
    id: PropTypes.number.isRequired,
    decisionBranches: decisionBranchTreePropType,
  }),
  questionsRepo: PropTypes.object.isRequired, // FIXME より詳細に
  decisionBranchesRepo: PropTypes.object.isRequired, // FIXME より詳細に
  openedNodes: openedNodesType.isRequired,
  onClickAnswerNode: PropTypes.func.isRequired,
  onClickDecisionBranchNode: PropTypes.func.isRequired,
};

export default AnswerNode;
