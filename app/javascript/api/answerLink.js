import axios from 'axios'
import config from './config'

export function create({ botToken, decisionBranchId, answerRecordType, answerRecordId }) {
  const path = `/api/bots/${botToken}/decision_branches/${decisionBranchId}/answer_link`;
  return axios.post(path, {
    answer_link: {
      answer_record_type: answerRecordType,
      answer_recrod_id: answerRecordId
    }
  }, config())
}

export function destroy({ botToken, decisionBranchId }) {
  const path = `/api/bots/${botToken}/decision_branches/${decisionBranchId}/answer_link`;
  return axios.delete(path, config())
}