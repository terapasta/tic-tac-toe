import { combineReducers } from 'redux'

import openedNodes from './reducers/openedNodes'
import activeItem from './reducers/activeItem'
import questionsTree from './reducers/questionsTree'
import questionsRepo from './reducers/questionsRepo'
import decisionBranchesRepo from './reducers/decisionBranchesRepo'

function through(state = null) {
  return state
}

const app = combineReducers({
  botId: through,
  questionsTree,
  questionsRepo,
  decisionBranchesRepo,
  openedNodes,
  activeItem
})

export default app
