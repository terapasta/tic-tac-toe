import React, { Component } from 'react'
import assign from 'lodash/assign'
import sortBy from 'lodash/sortBy'
import isEqual from 'lodash/isEqual'
import includes from 'lodash/includes'
import findLastIndex from 'lodash/findLastIndex'
import takeRight from 'lodash/takeRight'
import isEmpty from 'is-empty'
import imagesLoaded from 'imagesloaded'

import Mixpanel, { makeEvent } from '../../analytics/mixpanel'

import * as a from './ActionCreators'

import ChatHeader from './Header'
import ChatArea from './Area'
import ChatForm from './Form'
import ChatSection from './Section'
import ChatDecisionBranchesRow from './DecisionBranchesRow'
import ChatSimilarQuestionAnswersRow from './SimilarQuestionAnswersRow'
import ChatBotMessageRow from './BotMessageRow'
import ChatGuestMessageRow from './GuestMessageRow'
import ChatReadMore from './ReadMore'
import ChatFlashMessage from './FlashMessage'

let isFetchedInitialQuestions = false;

export default class ChatApp extends Component {
  static get componentName() {
    return "ChatApp";
  }

  static get propTypes() {
    return {};
  }

  componentDidMount() {
    a.trackMixpanel("Open new chat");
    const { dispatch, token } = this.props;
    dispatch(a.fetchMessages(token));
  }

  componentDidUpdate(prevProps, prevState) {
    scrollToLastSectionIfNeeded(prevProps, this, this.area);
    this.fetchInitialQuestionsIfNeeded();
    this.setInitialQuestionsToMessagesIfNeeded(prevProps);
  }

  fetchInitialQuestionsIfNeeded() {
    if (isFetchedInitialQuestions) { return; }
    isFetchedInitialQuestions = true;
    const { dispatch, messages, initialQuestions, isManager } = this.props;
    if (!isEmpty(messages.classifiedData) && isEmpty(initialQuestions) && isManager) {
      dispatch(a.fetchInitialQuestions(window.currentBot.id));
    }
  }

  setInitialQuestionsToMessagesIfNeeded(prevProps) {
    const { dispatch } = this.props;
    const prevInitialQuestions = sortBy(prevProps.initialQuestions, (q) => q.id);
    const initialQuestions = sortBy(this.props.initialQuestions, (q) => q.id);
    const isUpdated = (
      prevInitialQuestions.length !== initialQuestions.length ||
      includes(prevInitialQuestions.map((q, i) => isEqual(q, initialQuestions[i])), false)
    );

    if (isUpdated) {
      dispatch(a.setInitialQuestionsToMessages(this.props.initialQuestions));
    }
  }

  render() {
    const {
      dispatch,
      token,
      messages,
      form,
      learning,
      learnings,
      isAdmin,
      isManager,
      readMore,
      flashMessage,
      initialQuestions,
      isRegisteredGuestUser,
      isEnableGuestUserRegistration,
    } = this.props;

    const {
      classifiedData
    } = messages;

    return (
      <div ref="root" style={{ height: '100%' }}>
        <ChatHeader {...{
          botName: window.currentBot.name,
          learningStatus: learning.status,
          isAdmin,
          isManager,
          isRegisteredGuestUser,
          isEnableGuestUserRegistration,
          onClickStartLearning() { dispatch(a.startLearning(window.currentBot.id)) },
        }} />
        <ChatArea innerref={node => this.area = node}>
          <ChatFlashMessage flashMessage={flashMessage} />
          <ChatReadMore {...assign({
            isManager,
            onClick(e) {
              e.preventDefault();
              dispatch(a.fetchNextMessages());
            },
          }, readMore)} />
          {classifiedData.map((section, i) => {
            const isFirst = i === 0;
            const { isActive, isDisabled } = section;
            return (
              <ChatSection {...{
                  isManager,
                  isFirst,
                  isActive,
                  isDisabled,
                  key: i,
                  index: i,
                  section,
                  learnings,
                  scrollableElement: this.area,
                  onClick(index) {
                    dispatch(a.toggleActiveSection(index));
                  },
                  onSaveLearning(payload) {
                    dispatch(a.saveLearning(payload));
                  }
                }}>
                <ChatGuestMessageRow {...{
                  section,
                  isActive,
                  learnings,
                  onChangeLearning(payload) {
                    dispatch(a.updateLearning(payload));
                  },
                }} />
                <ChatBotMessageRow {...{
                  section,
                  isAdmin,
                  isManager,
                  isFirst,
                  isLastPage: messages.meta.currentPage === messages.meta.totalPages,
                  isActive,
                  learnings,
                  initialQuestions,
                  onChangeRatingTo(type, messageId) {
                    dispatch(a.changeMessageRatingTo(type, token, messageId));
                  },
                  onChangeLearning(payload) {
                    dispatch(a.updateLearning(payload));
                  },
                  onChangeInitialQuestions() {
                    dispatch(a.fetchInitialQuestions(window.currentBot.id));
                  },
                }} />
                <ChatDecisionBranchesRow {...{
                  section,
                  onChoose(decisionBranchId) {
                    dispatch(a.chooseDecisionBranch(token, decisionBranchId));
                  }
                }} />
                <ChatSimilarQuestionAnswersRow {...{
                  section,
                  onChoose(question) {
                    dispatch(a.postMessageIfNeeded(token, question, { isForce: true }));
                    const { eventName, options } = makeEvent('click suggest');
                    Mixpanel.sharedInstance.trackEvent(eventName, options);
                  }
                }} />
              </ChatSection>
            );
          })}
        </ChatArea>
        <ChatForm {...assign({
          onChange(e){
            dispatch(a.changeMessageBody({ messageBody: e.target.value }));
          },
          onSubmit(messageBody){
            dispatch(a.postMessageIfNeeded(token, messageBody));
          },
        }, form)} />
      </div>
    );
  }
}

function scrollToLastSectionIfNeeded(prevProps, component, scrollableElement) {
  if (scrollableElement == null) { return; }
  const { props: { messages } } = component;
  const prevCount = prevProps.messages.classifiedData.length
  const currentCount = messages.classifiedData.length;
  if (prevCount === 0) {
    // scroll to bottom
    imagesLoaded(scrollableElement, () => {
      scrollableElement.scrollTop = scrollableElement.scrollHeight;
    });
    return;
  }
  if (!messages.isNeedScroll) { return; }
  if (currentCount > prevCount) {
    // scroll to last answer
    const sectionElements = [].slice.call(scrollableElement.children)
      .filter((it) => it.hasAttribute('data-decision-branch'));
    const lastAnswerIndex = findLastIndex(sectionElements,
      it => it.getAttribute('data-decision-branch') === 'false');
    const secEls = takeRight(sectionElements, currentCount - lastAnswerIndex);
    imagesLoaded(secEls, () => {
      const total = secEls.reduce((sum, it) => {
        return sum + it.offsetHeight;
      }, 0);
      scrollableElement.scrollTop = scrollableElement.scrollHeight - total - 95;
    });
  }
}
