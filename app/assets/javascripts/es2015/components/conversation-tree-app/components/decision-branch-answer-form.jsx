import isEmpty from 'is-empty';

import {
  activeItemType,
  decisionBranchesRepoType,
} from '../types';

import BaseAnswerForm from './base-answer-form';

class DecisionBranchAnswerForm extends BaseAnswerForm {}

DecisionBranchAnswerForm.getAnswerAndDecisionBranches = (props) => {
  const { activeItem, decisionBranchesRepo } = props;
  const { answer } = decisionBranchesRepo[activeItem.node.id];
  const decisionBranches = activeItem.node.childDecisionBranches.map(db => (
    decisionBranchesRepo[db.id]
  ));
  return { answer, decisionBranches };
};

DecisionBranchAnswerForm.onCreateDecisionBranch = (props, body) => {
  if (isEmpty(body)) { return; }
  const { activeItem, onCreateDecisionBranch } = props;
  return onCreateDecisionBranch(activeItem.node.id, body);
};

DecisionBranchAnswerForm.onUpdateDecisionBranch = (props, id, body) => {
  if (isEmpty(body)) { return; }
  const { activeItem, onUpdateDecisionBranch } = props;
  return onUpdateDecisionBranch(activeItem.node.id, id, body);
};

DecisionBranchAnswerForm.onDeleteDecisionBranch = (props, id) => {
  if (window.confirm('本当に削除してよろしいですか？')) {
    const { activeItem, onDeleteDecisionBranch } = props;
    return onDeleteDecisionBranch(activeItem.node.id, id);
  }
};

DecisionBranchAnswerForm.propTypes = {
  activeItem: activeItemType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
};

export default DecisionBranchAnswerForm;
