import * as AnswerLinkAPI from '../../../api/answerLink'

export const createAnswerLink = ({
  botToken,
  decisionBranchId,
  answerRecordType,
  answerRecordId
}) => ((dispatch) => {
  return AnswerLinkAPI.create({
    botToken,
    decisionBranchId,
    answerRecordType,
    answerRecordId,
  }).then((res) => {
    console.log('success')
  }).catch((res) => {
    console.error(res)
  })
})