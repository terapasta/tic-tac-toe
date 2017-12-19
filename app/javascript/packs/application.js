import "babel-polyfill";
import promiseMiddleware from 'redux-promise'

import AnswerTextArea from '../components/AnswerTextArea'
import BotResetForm from '../components/BotResetForm'
import CopyButton from '../components/CopyButton'
import ChatApp from '../components/Chat/App'
import ChatAppReducers from '../components/Chat/Reducers'
import ConversationTree from '../components/ConversationTreeApp/App'
import ConversationTreeReducers from '../components/ConversationTreeApp/reducers'
import EmbedCodeGenerator from '../components/EmbedCodeGenerator'
import LearningButton from '../components/LearningButton'
import Mixpanel from '../analytics/mixpanel'
import QuestionAnswerTagForm from '../components/QuestionAnswerTagForm'
import WordMappings from '../components/WordMappings'

import mountComponent, { mountComponentWithRedux } from '../helpers/mountComponent'

function init() {
  Mixpanel.initialize("3c53484fb604d6e20438b4fac8d2ea56")
  Mixpanel.listenEvents()
  CopyButton.initialize()

  mountComponent(AnswerTextArea)
  mountComponent(BotResetForm)
  mountComponentWithRedux(ChatApp, ChatAppReducers, [promiseMiddleware])
  mountComponentWithRedux(ConversationTree, ConversationTreeReducers)
  mountComponent(EmbedCodeGenerator)
  mountComponent(LearningButton)
  mountComponent(QuestionAnswerTagForm)
  mountComponent(WordMappings)
}

if (document.readyState === "complete") {
  init()
} else {
  document.addEventListener("DOMContentLoaded", init)
}

