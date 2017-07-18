import isEmpty from 'is-empty';

import {
  activeItemType,
  questionsRepoType,
  decisionBranchesRepoType,
} from '../types';

import BaseAnswerForm from './base-answer-form';

class AnswerForm extends BaseAnswerForm {}

AnswerForm.getAnswerAndDecisionBranches = (props) => {
  const { activeItem, questionsRepo, decisionBranchesRepo } = props;
  const { answer } = questionsRepo[activeItem.node.id];
  const decisionBranches = activeItem.node.decisionBranches.map(db => (
    decisionBranchesRepo[db.id]
  ));
  return { answer, decisionBranches };
};

AnswerForm.onCreateDecisionBranch = (props, body) => {
  if (isEmpty(body)) { return; }
  const { activeItem, onCreateDecisionBranch } = props;
  return onCreateDecisionBranch(activeItem.node.id, body);
};

AnswerForm.onUpdateDecisionBranch = (props, id, body) => {
  if (isEmpty(body)) { return; }
  const { activeItem, onUpdateDecisionBranch } = props;
  return onUpdateDecisionBranch(activeItem.node.id, id, body);
};

AnswerForm.propTypes = {
  activeItem: activeItemType.isRequired,
  questionsRepo: questionsRepoType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
};

export default AnswerForm;
