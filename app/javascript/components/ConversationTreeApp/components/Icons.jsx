import styled from 'styled-components'

const iconBaseStyle = `
  margin-right: 5px;
  font-size: 18px;
  vertical-align: middle;
  color: #aaa;
`

export const QuestionIcon = styled.i.attrs({
  className: 'material-icons',
  title: '質問',
  children: 'comment'
})`
  ${iconBaseStyle}
`

export const AnswerIcon = styled.i.attrs({
  className: 'material-icons',
  title: '回答',
  children: 'chat_bubble_outline'
})`
  ${iconBaseStyle}
`

export const DecisionBranchIcon = styled.i.attrs({
  className: 'material-icons upside-down',
  title: '選択肢',
  children: 'call_split'
})`
  ${iconBaseStyle}
`