import React, { Component, PropTypes } from "react";

import Tree from "./tree";
import MasterDetailPanel, { Master, Detail } from "./master-detail-panel";
import ConversationItemForm from "./conversation-item-form";

import * as a from "./conversation-tree/action-creators";

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

  render() {
    const {
      dispatch,
      isProcessing,
      answersTree,
      answersRepo,
      decisionBranchesRepo,
      activeItem,
      editingAnswerModel,
      editingDecisionBranchModel,
      editingDecisionBranchModels,
      openedAnswerIds,
      openedDecisionBranchIds,
      isAddingAnswer,
      isAddingDecisionBranch,
    } = this.props;

    return (
      <MasterDetailPanel title="会話ツリー">
        <Master>
          <Tree
            answersTree={answersTree}
            answersRepo={answersRepo}
            decisionBranchesRepo={decisionBranchesRepo}
            activeItem={activeItem}
            openedAnswerIds={openedAnswerIds}
            openedDecisionBranchIds={openedDecisionBranchIds}
            isAddingAnswer={isAddingAnswer}
            onSelectItem={(dataType, id) => {
              dispatch(a.toggleOpenedIds(dataType, id));
              dispatch(a.setActiveItem(dataType, id));
            }}
            onCreatingAnswer={() => {
              dispatch(a.setActiveItem("answer", null));
            }}
          />
        </Master>
        <Detail>
          <ConversationItemForm
            isProcessing={isProcessing}
            activeItem={activeItem}
            editingAnswerModel={editingAnswerModel}
            editingDecisionBranchModel={editingDecisionBranchModel}
            editingDecisionBranchModels={editingDecisionBranchModels}
            isAddingDecisionBranch={isAddingDecisionBranch}
            onSaveAnswer={(answerModel, body, decisionBranchId) => {
              if (answerModel.id == null) {
                dispatch(a.addAnswerToAnswersTree(body, decisionBranchId));
              } else {
                dispatch(a.updateAnswerModel(answerModel, { body }));
              }
            }}
            onSaveDecisionBranch={(decisionBranchModel, body) => {
              if (decisionBranchModel.id == null) {
                dispatch(a.addDecisionBranchToAnswersTree(body));
              } else {
                dispatch(a.updateDecisionBranchModel(decisionBranchModel, { body }));
              }
            }}
            onEditDecisionBranch={(index) => {
               dispatch(a.activateEditingDecisionBranchModel(index));
            }}
            onAddingDecisionBranch={() => {
              dispatch(a.onAddingDecisionBranch());
            }}
            onCancelAddingDecisionBranch={() => {
              dispatch(a.offAddingDecisionBranch());
            }}
            onSaveNewDecisionBranch={(body) => {
              dispatch(a.addDecisionBranchToAnswersTree(body, activeItem.id));
            }}
          />
        </Detail>
      </MasterDetailPanel>
    );
  }
}
