import React, { Component, PropTypes } from 'react';
import classnames from 'classnames';
import isEmpty from 'is-empty';
import includes from 'lodash/includes';

import { decisionBranchTreePropType, openedNodesType } from '../helpers';
import Tree from './tree';
import AnswerNode from './answer-node';

class QuestionNode extends Component {
  constructor(props) {
    super(props);
    this.state = {};
    this.onClickQuestionNode = this.onClickQuestionNode.bind(this);
  }

  onClickQuestionNode(e) {
    e.stopPropagation();
    const { node, questionsRepo, onClickQuestionNode } = this.props
    const { answer } = questionsRepo[node.id];
    if (isEmpty(answer)) { return; }
    onClickQuestionNode(node.id)
  }

  render() {
    const {
      node,
      questionsRepo,
      decisionBranchesRepo,
      openedNodes,
      onClickAnswerNode,
      onClickDecisionBranchNode,
    } = this.props;

    const { question, answer } = questionsRepo[node.id];
    const isOpened = includes(openedNodes.questionIds, node.id);
    const itemClassName = classnames('tree__item', {
      'tree__item--no-children': isEmpty(answer),
      'tree__item--opened': isOpened,
      'active': false,
    });

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
        <Tree isOpened={isOpened}>
          <AnswerNode
            node={node}
            questionsRepo={questionsRepo}
            decisionBranchesRepo={decisionBranchesRepo}
            openedNodes={openedNodes}
            onClickAnswerNode={onClickAnswerNode}
            onClickDecisionBranchNode={onClickDecisionBranchNode}
          />
        </Tree>
      </li>
    );
  }
}

QuestionNode.propTypes = {
  node: PropTypes.shape({
    id: PropTypes.number.isRequired,
    decisionBranches: decisionBranchTreePropType,
  }),
  questionsRepo: PropTypes.object.isRequired, // FIXME より詳細に
  decisionBranchesRepo: PropTypes.object.isRequired, // FIXME より詳細に
  openedNodes: openedNodesType.isRequired,
  onClickQuestionNode: PropTypes.func.isRequired,
  onClickAnswerNode: PropTypes.func.isRequired,
  onClickDecisionBranchNode: PropTypes.func.isRequired,
};

QuestionNode.defaultProps = {
};

export default QuestionNode;
