import React from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import isEmpty from 'is-empty'
import get from 'lodash/get'

import {
  decisionBranchType,
  questionsTreeType,
  questionsRepoType,
  decisionBranchesRepoType
} from '../types'

import { QuestionIcon, AnswerIcon, DecisionBranchIcon } from './Icons'
import ToolTip from '../../ToolTip'

const Card = styled.div.attrs({
  className: 'card mb-2'
})`
  ${props => props.clickable && `
  `}

  ${props => props.unclickable && `
  `}

  ${props => props.selected && `
  `}
`

const Node = styled.div`
  ${props => props.indent && `
  `}
`

const isQuestionAnswerLinked = (answerLink, id) => (
  get(answerLink, 'answerRecordType') === 'QuestionAnswer' &&
    get(answerLink, 'answerRecordId') === id
)

const Item = props => (
  <Card
    clickable={props.clickable}
    unclickable={props.unclickable}
    selected={props.selected}
    onClick={props.onClick}
  >
    <div className="card-body p-2">
      {props.children}
    </div>
  </Card>
)

const QuestionNode = props => (
  <Node>
    <Item unclickable>
      <QuestionIcon />{props.data.question}
    </Item>
    <AnswerNode
      type="QuestionAnswer"
      data={props.data}
      node={props.node}
      decisionBranchesRepo={props.decisionBranchesRepo}
      subjectData={props.subjectData}
      onSelectLinkedAnswer={props.onSelectLinkedAnswer}
      onDeselectLinkedAnswer={props.onDeselectLinkedAnswer}
    />
  </Node>
)

const AnswerNode = props => {
  const {
    node: { decisionBranches, childDecisionBranches },
    decisionBranchesRepo,
    subjectData,
    onSelectLinkedAnswer,
    onDeselectLinkedAnswer,
    type,
    data
  } = props
  const dbNodes = decisionBranches || childDecisionBranches || []
  const { answerRecordType, answerRecordId } = get(subjectData, 'answerLink', {})
  const isSelected = answerRecordType === type && answerRecordId === data.id
  const clickHandler = isSelected ? onDeselectLinkedAnswer : onSelectLinkedAnswer

  return (
    <Node indent>
      <ToolTip title={`クリックで選択${isSelected ? 'を解除' : ''}`}>
        <Item
          clickable
          selected={isSelected}
          onClick={() => clickHandler(subjectData)}
        >
          <AnswerIcon />{data.answer}
        </Item>
      </ToolTip>
      {dbNodes.map(node => {
        const data = decisionBranchesRepo[node.id]
        if (isEmpty(data)) { return null }
        return <DecisionBranchNode
          data={data}
          node={node}
          decisionBranchesRepo={decisionBranchesRepo}
          key={node.id}
          subjectData={subjectData}
          onSelectLinkedAnswer={onSelectLinkedAnswer}
          onDeselectLinkedAnswer={onDeselectLinkedAnswer}
        />
      })}
    </Node>
  )
}

const DecisionBranchNode = props => {
  const {
    data,
    node,
    decisionBranchesRepo,
    subjectData,
    onSelectLinkedAnswer,
    onDeselectLinkedAnswer,
  } = props
  const isSelf = data.id === subjectData.id

  return (
    <Node indent>
      <Item unclickable>
        <DecisionBranchIcon />
        {data.body}
        {isSelf && (<span><br /><small>現在の選択肢</small></span>)}
      </Item>
      {!isEmpty(data.answer) && (
        <AnswerNode
          type="DecisionBranch"
          data={data}
          node={node}
          decisionBranchesRepo={decisionBranchesRepo}
          subjectData={subjectData}
          onSelectLinkedAnswer={onSelectLinkedAnswer}
          onDeselectLinkedAnswer={onDeselectLinkedAnswer}
        />
      )}
    </Node>
  )
}

const SelectableTree = props => {
  return (
    <div>
      {props.questionsTree.map(node => (
        <QuestionNode
          key={node.id}
          data={props.questionsRepo[node.id]}
          node={node}
          decisionBranchesRepo={props.decisionBranchesRepo}
          subjectData={props.data}
          onSelectLinkedAnswer={props.onSelectLinkedAnswer}
          onDeselectLinkedAnswer={props.onDeselectLinkedAnswer}
        />
      ))}
    </div>
  )
}
SelectableTree.propTypes = {
  data: decisionBranchType.isRequired,
  questionsTree: questionsTreeType.isRequired,
  questionsRepo: questionsRepoType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
  onSelectLinkedAnswer: PropTypes.func.isRequired,
  onDeselectLinkedAnswer: PropTypes.func.isRequired,
}

export default SelectableTree