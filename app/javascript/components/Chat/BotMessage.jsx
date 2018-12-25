import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Loading from 'react-loading'
// import Linkify from 'react-linkify'
// import nl2br from 'react-nl2br'
import values from 'lodash/values'
import includes from 'lodash/includes'
import last from 'lodash/last'
import classNames from 'classnames'
import isEmpty from 'is-empty'
import bytes from 'bytes'
import marked from 'marked'
import striptags from 'striptags'

import * as c from './Constants'

import MessageRatingButtons from './MessageRatingButtons'
import ImageFileTypes from '../../helpers/imageFileTypes'
import CollapsibleLog from './CollapsibleLog'

const autoLink = (text, options = {}) => {
  if (text == null) { return text }
  return text.replace(
    /(?!\]\()((https?:\/\/)|(www\.))(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-/]))?/gi,
    (...args) => {
      const url = args[0]
      const start = args[args.length - 2]
      const beforeTwo = (text[start - 2] || '') + (text[start - 1] || '')
      if (beforeTwo === '](') { return url }

      let fullUrl = url
      if (!fullUrl.match('^https?://')) {
        fullUrl = 'http://' + fullUrl
      }
      let link = document.createElement('a')
      link.textContent = url
      link.href = fullUrl
      const attrs = options.attrs || {}
      Object.keys(attrs).forEach(key => {
        link.setAttribute(key, attrs[key])
      })
      if (options.target) {
        link.setAttribute('target', options.target)
      }
      return link.outerHTML
    }
  )
}

export default class ChatBotMessage extends Component {
  static get propTypes () {
    return {
      isAdmin: PropTypes.bool.isRequired,
      isFirst: PropTypes.bool.isRequired,
      isLoading: PropTypes.bool,
      iconImageUrl: PropTypes.string,
      id: PropTypes.number.isRequired,
      body: PropTypes.string.isRequired,
      rating: PropTypes.oneOf(values(c.Ratings)),
      onChangeRatingTo: PropTypes.func.isRequired,
      answerFailed: PropTypes.bool.isRequired,
      replyLog: PropTypes.object
    }
  }

  constructor (props) {
    super(props)
    this.state = {
      isFaded: true
    }
  }

  componentDidMount () {
    setTimeout(() => { this.setState({ isFaded: false }) }, 0)
  }

  render () {
    const {
      isAdmin,
      isFirst,
      isLoading,
      iconImageUrl,
      id,
      rating,
      body,
      onChangeRatingTo,
      answerFailed,
      replyLog
    } = this.props

    const { isFaded } = this.state
    const className = classNames('chat-message wide', { 'faded': isFaded })
    const iconStyle = {
      backgroundImage: `url(${iconImageUrl})`
    }

    // markedの時点でバックスラッシュ2つがエスケープされてしまうため置換しておく
    const replaced = autoLink(body, { target: '_blank' }).replace(/\\/g, '\\\\')
    const markdowned = marked(replaced)
    const striped = striptags(markdowned, ['img', 'a'])
    const renderedBody = striped.replace(/\n/g, '<br />')

    return (
      <div className={className} id={`message-${id}`}>
        <div className='chat-message__icon' style={iconStyle} key='icon' />
        <div className='chat-message__balloon' key='balloon'>
          {answerFailed && <i className='material-icons mi-xs text-muted mr-1'>error_outline</i>}
          {!isLoading && (
            <span dangerouslySetInnerHTML={{ __html: renderedBody }} />
          )}
          {isLoading && (
            <div className='chat-message__balloon-loader'>
              <Loading type='spin' color='#e3e3e3' height={32} width={32} />
            </div>
          )}
          {this.renderAnswerFiles()}
        </div>
        <div className='chat-message__rating' key='rating'>
          {!isLoading && !isFirst && (
            <MessageRatingButtons {...{
              messageId: id,
              rating,
              onChangeRatingTo
            }} />
          )}
        </div>
        {isAdmin && !isEmpty(replyLog) && (
          <div className='chat-message__rating' key='probability'>
            <CollapsibleLog obj={replyLog} />
          </div>
        )}
      </div>
    )
  }

  renderAnswerFiles () {
    const { answerFiles } = this.props
    if (isEmpty(answerFiles)) { return null }

    return (
      <div>
        {answerFiles.map((answerFile, i) => {
          const isImage = includes(ImageFileTypes, answerFile.fileType)
          const fileName = last(answerFile.file.url.split('?')[0].split('/'))

          return (
            <div className='chat-message__file' key={i}>
              {isImage && (
                <a href={answerFile.file.url} target='_blank'>
                  <img src={answerFile.file.url} alt='添付ファイル' />
                </a>
              )}
              {!isImage && (
                <a href={answerFile.file.url} target='_blank'>{window.decodeURIComponent(fileName)}</a>
              )}
              <br />
              <small>ファイルタイプ：{answerFile.fileType}, ファイル容量：{bytes(answerFile.fileSize)}</small>
            </div>
          )
        })}
      </div>
    )
  }
}
