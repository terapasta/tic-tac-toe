import React, { Component, PropTypes } from 'react';
import isEmpty from 'is-empty';
import pick from 'lodash/pick';
import map from 'lodash/map';
import values from 'lodash/values';
import classnames from 'classnames';

import { decisionBranchTreePropType, openedNodesType } from '../helpers';
import Tree from './tree';
import AnswerNode from './answer-node';

class DecisionBranchNodes extends Component {
  onClickDecisionBranchNode(node, e) {
    e.stopPropagation();
    const { onClickDecisionBranchNode } = this.props;
    // TODO decisionBranchesRepoをチェックして適宜return
    onClickDecisionBranchNode(node.id);
  }

  renderDecisionBranchNode(node) {
    const { decisionBranchesRepo } = this.props;
    const { body, answer } = decisionBranchesRepo[node.id];
    const childDecisionBranches = values(pick(decisionBranchesRepo, map(node.childDecisionBranches, 'id')));

    return (
      <li
        className="tree__node"
        onClick={(e) => this.onClickDecisionBranchNode(node, e)}
        key={node.id}
      >
        <div className="tree__item">
          <div className="tree__item-body">
            <i className="material-icons upside-down" title="選択肢">call_split</i>
              {body}
          </div>
        </div>
        {!isEmpty(answer) && (
          <Tree>
            {this.renderAnswerNode(answer, node.childDecisionBranches)}
          </Tree>
        )}
      </li>
    );
  }

  renderAnswerNode(answer, childDecisionBranchNodes) {
    const itemClassName = classnames('tree__item', {
      'tree__item--no-children': isEmpty(childDecisionBranchNodes),
      'tree__item--opened': false,
      'active': false,
    });

    return (
      <li
        className="tree__node"
      >
        <div className={itemClassName}>
          <div className="tree__item-body">
            <i className="material-icons" title="質問">chat_bubble_outline</i>
            {answer}
          </div>
        </div>
        {!isEmpty(childDecisionBranchNodes) && (
          <Tree>
            {childDecisionBranchNodes.map((node) => {
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
  openedNodes: openedNodesType,
  onClickDecisionBranchNode: PropTypes.func.isRequired,
};

export default DecisionBranchNodes;
