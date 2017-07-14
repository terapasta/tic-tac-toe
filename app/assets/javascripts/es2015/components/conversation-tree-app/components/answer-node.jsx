import React, { Component } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';
import includes from 'lodash/includes';
import isEmpty from 'is-empty';

import {
  decisionBranchTreePropType,
  openedNodesType,
  answerNodeKey,
} from '../helpers';

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
      activeItem,
      onClickAnswerNode,
      onClickDecisionBranchNode,
      onClickDecisionBranchAnswerNode,
    } = this.props;

    const { answer } = questionsRepo[node.id];
    const isOpened = includes(openedNodes, answerNodeKey(node.id));
    const itemClassName = classnames('tree__item', {
      'tree__item--no-children': isEmpty(node.decisionBranches),
      'tree__item--opened': isOpened,
      'active': activeItem.nodeKey === answerNodeKey(node.id),
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
              activeItem={activeItem}
              onClickAnswerNode={onClickAnswerNode}
              onClickDecisionBranchNode={onClickDecisionBranchNode}
              onClickDecisionBranchAnswerNode={onClickDecisionBranchAnswerNode}
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
  activeItem: PropTypes.shape({
    nodeKey: PropTypes.string,
  }).isRequired,
  onClickAnswerNode: PropTypes.func.isRequired,
  onClickDecisionBranchNode: PropTypes.func.isRequired,
};

export default AnswerNode;
