import isEmpty from 'is-empty'

import {
  activeItemType,
  decisionBranchesRepoType,
} from '../types'

import BaseAnswerForm from './BaseAnswerForm'

class DecisionBranchAnswerForm extends BaseAnswerForm {}

DecisionBranchAnswerForm.getAnswerAndDecisionBranches = (props) => {
  const { activeItem, decisionBranchesRepo } = props;
  const decisionBranch = decisionBranchesRepo[activeItem.node.id];
  if (decisionBranch == null) {
    return { answer: '', decisionBranches: [] };
  }
  const { answer } = decisionBranch;
  const decisionBranches = activeItem.node.childDecisionBranches.map(db => (
    decisionBranchesRepo[db.id]
  ));
  return { answer, decisionBranches };
};

DecisionBranchAnswerForm.onUpdateAnswer = (props, answer) => {
  const { activeItem, decisionBranchesRepo, onUpdateAnswer } = props;
  const { body } = decisionBranchesRepo[activeItem.node.id];
  return onUpdateAnswer(activeItem.node.id, body, answer);
};

DecisionBranchAnswerForm.onDeleteAnswer = (props, body) => {
  if (window.confirm('本当に削除してよろしいですか？')) {
    const { activeItem, decisionBranchesRepo, onDeleteAnswer } = props;
    const { body } = decisionBranchesRepo[activeItem.node.id];
    return onDeleteAnswer(activeItem.node.id, body);
  }
};

DecisionBranchAnswerForm.onCreateDecisionBranch = (props, body) => {
  if (isEmpty(body)) { return; }
  const { activeItem, onCreateDecisionBranch } = props;
  return onCreateDecisionBranch(activeItem.node.id, body);
};

DecisionBranchAnswerForm.onUpdateDecisionBranch = (props, id, body) => {
  if (isEmpty(body)) { return; }
  const { onUpdateDecisionBranch } = props;
  return onUpdateDecisionBranch(id, body);
};

DecisionBranchAnswerForm.onDeleteDecisionBranch = (props, id) => {
  if (window.confirm('本当に削除してよろしいですか？')) {
    const { decisionBranchesRepo, onDeleteDecisionBranch } = props;
    const { parentDecisionBranchId } = decisionBranchesRepo[id];
    return onDeleteDecisionBranch(parentDecisionBranchId, id);
  }
};

DecisionBranchAnswerForm.propTypes = {
  activeItem: activeItemType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
};

export default DecisionBranchAnswerForm;
