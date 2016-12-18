import React, { Component, PropTypes } from "react";
import isArray from "lodash/isArray";

import Tree from "./tree";
import MasterDetailPanel, { Master, Detail } from "./master-detail-panel";
import ConversationItemForm from "./conversation-item-form";

export default class ConversationTree extends Component {
  static get componentName() {
    return "ConversationTree";
  }

  static get propTypes() {
    return {
      botId: PropTypes.number.isRequired,
      answersTree: PropTypes.array.isRequired,
      answersRepo: PropTypes.object.isRequired,
      decisionBranchesRepo: PropTypes.object.isRequired,
    };
  }

  constructor(props) {
    super(props);
    const { answersTree, answersRepo, decisionBranchesRepo } = props;
    this.state = {
      answersTree,
      answersRepo,
      decisionBranchesRepo,
      activeItem: null,
      isCreatingAnswer: false,
    };
  }

  render() {
    const { botId } = this.props;
    const {
      answersTree,
      answersRepo,
      decisionBranchesRepo,
      activeItem,
      isCreatingAnswer,
    } = this.state;

    return (
      <MasterDetailPanel title="会話ツリー">
        <Master>
          <Tree
            answersTree={answersTree}
            answersRepo={answersRepo}
            decisionBranchesRepo={decisionBranchesRepo}
            onSelectItem={this.onSelectItem.bind(this)}
            onCreatingAnswer={this.onCreatingAnswer.bind(this)}
          />
        </Master>
        <Detail>
          <ConversationItemForm
            botId={botId}
            activeItem={activeItem}
            onUpdateDecisionBranch={this.onUpdateDecisionBranch.bind(this)}
            onUpdateAnswer={this.onUpdateAnswer.bind(this)}
            isCreatingAnswer={isCreatingAnswer}
            onCreateAnswer={this.onCreateAnswer.bind(this)}
            onCreateDecisionBranch={this.onCreateDecisionBranch.bind(this)}
          />
        </Detail>
      </MasterDetailPanel>
    );
  }

  onSelectItem(activeItem) {
    this.setState({ activeItem });
  }

  onCreatingAnswer() {
    this.setState({ isCreatingAnswer: true });
  }

  onUpdateDecisionBranch(decisionBranchModel) {
    const { decisionBranchesRepo } = this.state;
    decisionBranchesRepo[decisionBranchModel.id] = decisionBranchModel.attrs;
    this.setState({ decisionBranchesRepo });
  }

  onUpdateAnswer(answerModel) {
    const { answersRepo } = this.state;
    answersRepo[answerModel.id] = answerModel.attrs;
    this.setState({ answersRepo });
  }

  onCreateAnswer(answerModel) {
    const { answersRepo, answersTree } = this.state;
    answersRepo[answerModel.id] = answerModel.attrs;
    answersTree.unshift({
      id: answerModel.id,
      decisionBranches: [],
    });
    const activeItem = { type: "answer", id: answerModel.id };
    this.setState({ answersRepo, answersTree, activeItem });
  }

  onCreateDecisionBranch(answerId, decisionBranchModel) {
    const { decisionBranchesRepo, answersTree } = this.state;
    decisionBranchesRepo[decisionBranchModel.id] = decisionBranchModel.attrs;
    findAnswerFromTree(answersTree, answerId, (answerNode) => {
      answerNode.decisionBranches.push({
        id: decisionBranchModel.id,
        answer: null,
      });
    });
    this.setState({ decisionBranchesRepo, answersTree });
  }
}

function findAnswerFromTree(answersTree, answerId, foundCallback) {
  answersTree.forEach((answerNode) => {
    if (answerNode.id === answerId) {
      foundCallback(answerNode);
    } else {
      const answers = answerNode.decisionBranches.map((db) => db.answer);
      findAnswerFromTree(answers, answerId);
    }
  });
}
