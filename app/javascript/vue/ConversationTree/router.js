import Vue from 'vue'
import Router from 'vue-router'

import Home from './components/Home'
import QuestionForm from './components/QuestionForm'
import AnswerForm from './components/AnswerForm'
import DecisionBranchForm from './components/DecisionBranchForm'
// import DecisionBranchAnswerForm from './components/DecisionBranchAnswerForm'

Vue.use(Router)

const router = new Router({
  mode: 'hash',
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/question/new',
      name: 'QuestionNew',
      component: QuestionForm
    },
    {
      path: '/question/:id',
      name: 'Question',
      component: QuestionForm
    },
    {
      path: '/answer/:id',
      name: 'Answer',
      component: AnswerForm
    },
    {
      path: '/decisionBranch/:id',
      name: 'DecisionBranch',
      component: DecisionBranchForm
    },
    {
      path: '/decisionBranchAnswer/:id',
      name: 'DecisionBranchAnswer',
      component: AnswerForm
    }
  ]
})

export default router