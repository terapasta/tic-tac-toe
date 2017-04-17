import axios from "axios";
import config from "./config"

export function create(token, { questionBody, answerBody, questionId, answerId }) {
  const path = `/embed/${token}/chats/trainings.json`;
  return axios.post(path, {
    question_answer: {
      question: questionBody,
      answer_attributes: {
        body: answerBody,
      },
    },
    question_message_id: questionId,
    answer_message_id: answerId,
  }, config());
}
