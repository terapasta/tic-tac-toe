import React, { Component, PropTypes } from 'react';
import isEmpty from 'is-empty';
import includes from 'lodash/includes';
import classnames from 'classnames';

import {
  decisionBranchTreePropType,
  activeItemType,
  openedNodesType,
} from '../types';

import {
  decisionBranchAnswerNodeKey,
  decisionBranchNodeKey,
} from '../helpers';

import Tree from './tree';

class DecisionBranchNodes extends Component {
  onClickDecisionBranchNode(node, e) {
    e.stopPropagation();
    this.props.onClickDecisionBranchNode(node);
  }

  onClickAnswerNode(node, e) {
    e.stopPropagation();
    this.props.onClickDecisionBranchAnswerNode(node);
  }

  renderDecisionBranchNode(node) {
    const { decisionBranchesRepo, openedNodes, activeItem } = this.props;
    const decisionBranch = decisionBranchesRepo[node.id];
    if (decisionBranch == null) { return null; }
    const { body, answer } = decisionBranch;

    const isOpened = includes(openedNodes, decisionBranchNodeKey(node.id));
    const itemClassName = classnames('tree__item', {
      'tree__item--no-children': isEmpty(answer),
      'tree__item--opened': isOpened,
      'active': activeItem.nodeKey === decisionBranchNodeKey(node.id),
    });

    return (
      <li
        className="tree__node"
        onClick={e => this.onClickDecisionBranchNode(node, e)}
        key={node.id}
      >
        <div className={itemClassName}>
          <div className="tree__item-body">
            <i className="material-icons upside-down" title="選択肢">call_split</i>
              {body}
          </div>
        </div>
        {!isEmpty(answer) && (
          <Tree isOpened={isOpened}>
            {this.renderAnswerNode(node)}
          </Tree>
        )}
      </li>
    );
  }

  renderAnswerNode(node) {
    const { openedNodes, decisionBranchesRepo, activeItem } = this.props;
    const { childDecisionBranches } = node;
    const { answer } = decisionBranchesRepo[node.id];
    const isOpened = includes(openedNodes, decisionBranchAnswerNodeKey(node.id));
    const itemClassName = classnames('tree__item', {
      'tree__item--no-children': isEmpty(childDecisionBranches),
      'tree__item--opened': isOpened,
      'active': activeItem.nodeKey === decisionBranchAnswerNodeKey(node.id),
    });

    return (
      <li
        className="tree__node"
        onClick={e => this.onClickAnswerNode(node, e)}
      >
        <div className={itemClassName}>
          <div className="tree__item-body">
            <i className="material-icons" title="質問">chat_bubble_outline</i>
            {answer}
          </div>
        </div>
        {!isEmpty(childDecisionBranches) && (
          <Tree isOpened={isOpened}>
            {childDecisionBranches.map((node) => {
              return this.renderDecisionBranchNode(node);
            })}
          </Tree>
        )}
      </li>
    );
  }

  render() {
    return (
      <div>
        {this.props.nodes.map(node => this.renderDecisionBranchNode(node))}
      </div>
    );
  }
}

DecisionBranchNodes.propTypes = {
  nodes: decisionBranchTreePropType,
  openedNodes: openedNodesType.isRequired,
  activeItem: activeItemType.isRequired,

  onClickAnswerNode: PropTypes.func.isRequired,
  onClickDecisionBranchNode: PropTypes.func.isRequired,
  onClickDecisionBranchAnswerNode: PropTypes.func.isRequired,
};

export default DecisionBranchNodes;
