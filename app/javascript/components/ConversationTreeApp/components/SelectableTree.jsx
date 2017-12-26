import React from 'react'
import styled from 'styled-components'
import isEmpty from 'is-empty'

import {
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
    cursor: pointer;
    &:hover {
      border-color: #007bff;
      background-color: #fff;
    }
  `}

  ${props => props.unclickable && `
    opacity: 0.5;
    border: 0;
  `}

  ${props => props.selected && `
    position: relative;
    border-color: #28a745;
    &::after {
      content: "✓";
      position: absolute;
      width: 20px;
      height: 20px;
      top: -10px;
      left: -10px;
      background-color: #28a745;
      border-radius: 10px;
      color: #fff;
      text-align: center;
      line-height: 20px;
    }
    &:hover {
      border-color: #aaa;
      &::after {
        background-color: #aaa;
      }
    }
  `}
`

const Node = styled.div`
  ${props => props.indent && `
    margin-left: 24px;
  `}
`

const Item = props => (
  <Card
    clickable={props.clickable}
    unclickable={props.unclickable}
    selected={props.selected}
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
      data={props.data}
      node={props.node}
      decisionBranchesRepo={props.decisionBranchesRepo}
    />
  </Node>
)

const AnswerNode = props => {
  const dbNodes = props.node.decisionBranches || props.node.childDecisionBranches || []
  return (
    <Node indent>
      <ToolTip title={'クリックで選択'}>
        <Item clickable selected>
          <AnswerIcon />{props.data.answer}
        </Item>
      </ToolTip>
      {dbNodes.map(node => {
        const data = props.decisionBranchesRepo[node.id]
        if (isEmpty(data)) { return null }
        return <DecisionBranchNode
          data={data}
          node={node}
          decisionBranchesRepo={props.decisionBranchesRepo}
          key={node.id}
        />
      })}
    </Node>
  )
}

const DecisionBranchNode = props => (
  <Node indent>
    <Item unclickable>
      <DecisionBranchIcon />
      {props.data.body}
    </Item>
    {!isEmpty(props.data.answer) && (
      <AnswerNode
        data={props.data}
        node={props.node}
        decisionBranchesRepo={props.decisionBranchesRepo}
      />
    )}
  </Node>
)

const SelectableTree = props => {
  return (
    <div>
      {props.questionsTree.map(node => (
        <QuestionNode
          key={node.id}
          data={props.questionsRepo[node.id]}
          node={node}
          decisionBranchesRepo={props.decisionBranchesRepo}
        />
      ))}
    </div>
  )
}
SelectableTree.propTypes = {
  questionsTree: questionsTreeType.isRequired,
  questionsRepo: questionsRepoType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired
}

export default SelectableTree