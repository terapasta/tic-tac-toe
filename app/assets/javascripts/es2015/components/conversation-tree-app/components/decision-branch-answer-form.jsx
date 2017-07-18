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

DecisionBranchAnswerForm.propTypes = {
  activeItem: activeItemType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
};

export default DecisionBranchAnswerForm;
