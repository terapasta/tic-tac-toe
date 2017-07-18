import { createAction } from 'redux-actions';

import * as QuestionAnswerAPI from '../../../api/question-answer';
import { setActiveItem, openNode } from '../action-creators';
import { questionNodeKey } from '../helpers';

export const succeedCreateQuestion = createAction('SUCCEED_CREATE_QUESTION');
export const failedCreateQuestion = createAction('FAILED_CREATE_QUESTION');

export const succeedUpdateQuestion = createAction('SUCCEED_UPDATE_QUESTION');
export const failedUpdateQuestion = createAction('FAILED_UPDATE_QUESTION');

export const succeedDeleteQuestion = createAction('SUCCEED_DELETE_QUESTION');
export const failedDeleteQuestion = createAction('FAILED_DELETE_QUESTION');

export const createQuestion = (question, answer) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return QuestionAnswerAPI.create(botId, question, answer).then((res) => {
      const { id, decisionBranches } = res.data.questionAnswer;
      const nodeKey = questionNodeKey(id);
      dispatch(succeedCreateQuestion(res.data));
      dispatch(setActiveItem({
        type: 'question',
        nodeKey,
        node: { id, decisionBranches },
      }));
      dispatch(openNode({ nodeKey }));
    }).catch((res) => {
      dispatch(failedCreateQuestion(res.data));
    });
  }
);

export const updateQuestion = (id, question, answer) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return QuestionAnswerAPI.update(botId, id, question, answer).then((res) => {
      console.log(res);
      dispatch(succeedUpdateQuestion(res.data));
    }).catch((res) => {
      console.log(res)
      dispatch(failedUpdateQuestion(res.data));
    });
  }
);

export const deleteQuestion = (id) => (
  (dispatch, getState) => {
    const { botId } = getState();
    return QuestionAnswerAPI.destroy(botId, id).then((res) => {
      console.log(res);
      dispatch(succeedDeleteQuestion(res.data));
    }).catch((res) => {
      console.log(res)
      dispatch(failedDeleteQuestion(res.data));
    });
  }
);
