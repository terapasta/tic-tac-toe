import React, { Component, PropTypes } from "react";
import flatten from "lodash/flatten";
import compact from "lodash/compact";
import includes from "lodash/includes";

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
      activeItem: { type: null, id: null },
      isCreatingAnswer: false,
      openedAnswerIDs: [],
      openedDecisionBranchIDs: [],
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
      openedAnswerIDs,
      openedDecisionBranchIDs,
    } = this.state;

    return (
      <MasterDetailPanel title="会話ツリー">
        <Master>
          <Tree
            answersTree={answersTree}
            answersRepo={answersRepo}
            activeItem={activeItem}
            decisionBranchesRepo={decisionBranchesRepo}
            onSelectItem={this.onSelectItem.bind(this)}
            onCreatingAnswer={this.onCreatingAnswer.bind(this)}
            openedAnswerIDs={openedAnswerIDs}
            openedDecisionBranchIDs={openedDecisionBranchIDs}
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
    let { openedAnswerIDs, openedDecisionBranchIDs } = this.state;
    switch (activeItem.type) {
      case "answer":
        openedAnswerIDs = toggleID(openedAnswerIDs, activeItem.id);
        break;
      case "decisionBranch":
        openedDecisionBranchIDs = toggleID(openedDecisionBranchIDs, activeItem.id);
        break;
    }
    this.setState({ activeItem, openedAnswerIDs, openedDecisionBranchIDs });
  }

  onCreatingAnswer() {
    this.setState({ isCreatingAnswer: true, activeItem: { type: null, id: null } });
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

  onCreateAnswer(answerModel, decisionBranchId) {
    const { answersRepo, answersTree } = this.state;
    answersRepo[answerModel.id] = answerModel.attrs;
    if (decisionBranchId == null) {
      answersTree.unshift({
        id: answerModel.id,
        decisionBranches: [],
      });
    } else {
      findDecisionBranchFromTree(answersTree, decisionBranchId, (decisionBranchNode) => {
        decisionBranchNode.answer = { id: answerModel.id, decisionBranches: [] };
      });
    }
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
    const activeItem = { type: "decisionBranch", id: decisionBranchModel.id };
    this.setState({ decisionBranchesRepo, answersTree, activeItem });
  }
}

function findAnswerFromTree(answersTree, answerId, foundCallback) {
  answersTree.forEach((answerNode) => {
    if (answerNode.id === answerId) {
      foundCallback(answerNode);
    } else {
      const answers = compact(answerNode.decisionBranches.map((db) => db.answer));
      findAnswerFromTree(answers, answerId, foundCallback);
    }
  });
}

function findDecisionBranchFromTree(answersTree, decisionBranchId, foundCallback) {
  const handler = (decisionBranchNodes) => {
    decisionBranchNodes.forEach((decisionBranchNode) => {
      if (decisionBranchNode.id === decisionBranchId) {
        foundCallback(decisionBranchNode);
      } else if (decisionBranchNode.answer != null) {
        handler(decisionBranchNode.answer.decisionBranches);
      }
    });
  };
  const decisionBranchNodes = flatten(answersTree.map((a) => a.decisionBranches));
  handler(decisionBranchNodes);
}

function toggleID(IDs, targetID) {
  let newIDs;
  if (includes(IDs, targetID)) {
    newIDs = IDs.filter((id) => id != targetID);
  } else {
    newIDs = IDs.concat([targetID]);
  }
  return newIDs;
}
