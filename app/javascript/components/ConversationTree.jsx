import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { findDOMNode } from 'react-dom'

import Mixpanel from '../analytics/mixpanel'
import getOffset from '../helpers/getOffset'

import Tree from "./tree";
import MasterDetailPanel, { Master, Detail } from './MasterDetailPanel'
import ConversationItemForm from './conversation-item-form'

import * as a from "./conversation-tree/action-creators";

export default class ConversationTree extends Component {
  static get componentName() {
    return "ConversationTree";
  }

  static get propTypes() {
    return {
      botId: PropTypes.number.isRequired,
      questionsTree: PropTypes.array.isRequired,
      questionsRepo: PropTypes.object.isRequired,
      decisionBranchesRepo: PropTypes.object.isRequired,
    };
  }

  componentDidMount() {
    this.adjsutMasterDetailPanelHeight();
    window.addEventListener("resize", this.adjsutMasterDetailPanelHeight.bind(this));
  }

  adjsutMasterDetailPanelHeight() {
    const masterDetailPanel = findDOMNode(this.refs.masterDetailPanel);
    const offset = getOffset(masterDetailPanel);
    const winHeight = window.innerHeight;
    const height = winHeight - offset.top - 20;
    masterDetailPanel.style.height = `${height}px`;
  }

  render() {
    const {
      dispatch,
      isProcessing,
      questionsTree,
      questionsRepo,
      answersTree,
      answersRepo,
      decisionBranchesRepo,
      activeItem,
      editingQuestionModel,
      editingAnswerModel,
      editingDecisionBranchModel,
      editingDecisionBranchModels,
      openedQuestionIds,
      openedAnswerIds,
      openedDecisionBranchIds,
      isAddingAnswer,
      isAddingDecisionBranch,
      referenceQuestionModels,
      botId, // TODO: botIdはここで触りたくない
    } = this.props;

    return (
      <MasterDetailPanel title="会話ツリー" ref="masterDetailPanel">
        <Master>
          <Tree
            {...{
              questionsTree,
              questionsRepo,
              answersTree,
              answersRepo,
              decisionBranchesRepo,
              openedQuestionIds,
              openedAnswerIds,
              openedDecisionBranchIds,
              activeItem,
              isAddingAnswer,
              onSelectItem(dataType, id) {
                Mixpanel.sharedInstance.trackEvent("Select tree node", { dataType, id });
                dispatch(a.toggleOpenedIds(dataType, id));
                dispatch(a.setActiveItem(dataType, id));
              },
              onCreatingQuestion() {
                Mixpanel.sharedInstance.trackEvent("New question node");
                dispatch(a.setActiveItem("question", null));
              },
            }}
          />
        </Master>
        <Detail>
          {/* TODO: botIdは渡したくない */}
          <ConversationItemForm
            {...{
              botId,
              isProcessing,
              activeItem,
              editingQuestionModel,
              editingAnswerModel,
              editingDecisionBranchModel,
              editingDecisionBranchModels,
              isAddingDecisionBranch,
              referenceQuestionModels,
              onSaveQuestion(questionModel, question, answerModel, answerBody) {
                const { id } = questionModel;
                Mixpanel.sharedInstance.trackEvent("Save question node", { questionId: id });
                if (id == null) {
                  dispatch(a.addQuestionToQuestionsTree(question, { answerModel, answerBody }));
                } else {
                  dispatch(a.updateQuestionModel(questionModel, { question }, { answerModel, answerBody }));
                }
              },
              onDeleteQuestion(questionModel) {
                Mixpanel.sharedInstance.trackEvent("Delete question node", { id: questionModel.id });
                dispatch(a.deleteQuestionFromQuestionsTree(questionModel));
              },
              onSaveAnswer(answerModel, body, decisionBranchId) {
                const { id } = answerModel;
                Mixpanel.sharedInstance.trackEvent("Save answer node", { answerId: id, decisionBranchId });
                if (id == null) {
                  dispatch(a.addAnswerToAnswersTree(body, { decisionBranchId }));
                } else {
                  dispatch(a.updateAnswerModel(answerModel, { body }));
                }
              },
              onDeleteAnswer(answerModel, decisionBranchId) {
                Mixpanel.sharedInstance.trackEvent("Delete answer node", { answerId: answerModel.id, decisionBranchId });
                dispatch(a.deleteAnswerFromAnswersTree(answerModel, decisionBranchId));
              },
              onSaveDecisionBranch(decisionBranchModel, body) {
                const { id } = decisionBranchModel;
                Mixpanel.sharedInstance.trackEvent("Save decision branch node", { decisionBranchId: id });
                if (id == null) {
                  dispatch(a.addDecisionBranchToQuestionsTree(body));
                } else {
                  dispatch(a.updateDecisionBranchModel(decisionBranchModel, { body }));
                }
              },
              onEditDecisionBranch(index) {
                Mixpanel.sharedInstance.trackEvent("Edit decision branch node");
                dispatch(a.activateEditingDecisionBranchModel(index));
              },
              onDeleteDecisionBranch(decisionBranchModel, answerId) {
                Mixpanel.sharedInstance.trackEvent("Delete decision branch node", { decisionBranchId: decisionBranchModel.id });
                dispatch(a.deleteDecisionBranchFromQuestionsTree(decisionBranchModel, answerId));
              },
              onAddingDecisionBranch() {
                Mixpanel.sharedInstance.trackEvent("Adding decision branch node");
                dispatch(a.onAddingDecisionBranch());
              },
              onCancelAddingDecisionBranch() {
                Mixpanel.sharedInstance.trackEvent("Cancel adding decision branch node");
                dispatch(a.offAddingDecisionBranch());
              },
              onSaveNewDecisionBranch(body) {
                Mixpanel.sharedInstance.trackEvent("Save decision branch node", { decisionBranchId: null });
                dispatch(a.addDecisionBranchToQuestionsTree(body, activeItem.id));
              },
            }}
          />
        </Detail>
      </MasterDetailPanel>
    );
  }
}