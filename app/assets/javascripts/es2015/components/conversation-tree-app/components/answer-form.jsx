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

AnswerForm.propTypes = {
  activeItem: activeItemType.isRequired,
  questionsRepo: questionsRepoType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
};

export default AnswerForm;
