import React, { Component, PropTypes } from "react";

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
    };
  }

  render() {
    const { botId } = this.props;
    const {
      answersTree,
      answersRepo,
      decisionBranchesRepo,
      activeItem,
    } = this.state;

    return (
      <MasterDetailPanel title="会話ツリー">
        <Master>
          <Tree
            answersTree={answersTree}
            answersRepo={answersRepo}
            decisionBranchesRepo={decisionBranchesRepo}
            onSelectItem={this.onSelectItem.bind(this)}
          />
        </Master>
        <Detail>
          <ConversationItemForm
            botId={botId}
            activeItem={activeItem}
            onUpdateDecisionBranch={this.onUpdateDecisionBranch.bind(this)}
            onUpdateAnswer={this.onUpdateAnswer.bind(this)}
          />
        </Detail>
      </MasterDetailPanel>
    );
  }

  onSelectItem(activeItem) {
    this.setState({ activeItem });
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
}
