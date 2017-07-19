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
  const question = questionsRepo[activeItem.node.id];
  if (question == null) {
    return { answer: '', decisionBranches: [] };
  }
  const { answer } = question;
  const decisionBranches = activeItem.node.decisionBranches.map(db => (
    decisionBranchesRepo[db.id]
  ));
  return { answer, decisionBranches };
};

AnswerForm.onUpdateAnswer = (props, answer) => {
  const { activeItem, questionsRepo, onUpdateAnswer } = props;
  const { question } = questionsRepo[activeItem.node.id];
  return onUpdateAnswer(activeItem.node.id, question, answer);
};

AnswerForm.onDeleteAnswer = (props) => {
  if (window.confirm('本当に削除してよろしいですか？')) {
    const { activeItem, questionsRepo, onDeleteAnswer } = props;
    const { question } = questionsRepo[activeItem.node.id];
    return onDeleteAnswer(activeItem.node.id, question);
  }
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

AnswerForm.onDeleteDecisionBranch = (props, id) => {
  if (window.confirm('本当に削除してよろしいですか？')) {
    const { activeItem, onDeleteDecisionBranch } = props;
    return onDeleteDecisionBranch(activeItem.node.id, id);
  }
};

AnswerForm.propTypes = {
  activeItem: activeItemType.isRequired,
  questionsRepo: questionsRepoType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
};

export default AnswerForm;
