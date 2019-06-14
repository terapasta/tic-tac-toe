import React, { Component } from "react";
import get from "lodash/get";

import * as PublicBotAPI from '../api/public_bot';

import {
  LoadingMessage,
  FloatWrapper
} from "./styled";

import {
  MobileMaxWidth,
  Position,
  MaxHeight,
  Margin,
  MoveButtonSize,
  MoveButtonMargin
} from './constants';
const MaxHeightSpace = Margin * 2 + MaxHeight + MoveButtonSize + MoveButtonMargin

const Origin = (() => {
  if (process.env.NODE_ENV === 'development') {
    return 'http://localhost:3000'
  }
  const isStaging = !!document.querySelector('script[src^="//my-ope-assets-stg"]')
  if (isStaging) {
    return 'https://staging.my-ope.net'
  }
  return 'https://app.my-ope.net'
})()

export default class Widget extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isActive: false,
      isLoadingIframe: false,
      isLoadedIframe: false,
      isDeniedAccess: true,
      position: Position.from(props.position),
      height: MaxHeight
    };

    this.fetchPulicBot(props.token);
    this.onLoadIframe = this.onLoadIframe.bind(this)
    this.handleFloatWrapperMove = this.handleFloatWrapperMove.bind(this)
  }

  fetchPulicBot(token) {
    PublicBotAPI.find(token, { origin: Origin }).then((res) => {
      this.setState({
        name: get(res, "data.bot.name"),
        avatarURL: get(res, "data.bot.image.thumb.url"),
        subtitle: get(res, "data.bot.widgetSubtitle"),
        isDeniedAccess: false,
      });
    }).catch(console.error);
  }

  componentWillUpdate(nextProps, nextState) {
    const isMobile = window.innerWidth <= MobileMaxWidth;
    if (!isMobile) { return; }
    let className = document.body.getAttribute('class') || '';
    if (!this.state.isActive && nextState.isActive) {
      className += ' prevent-scroll';
    } else if (this.state.isActive && !nextState.isActive) {
      className = className.replace(' prevent-scroll', '');
    }
    if (className != null) {
      document.body.setAttribute('class', className);
    }
  }

  componentDidMount() {
    window.addEventListener('resize', this.reviseHeight.bind(this))
  }

  componentDidUpdate(prevProps, prevState) {
    if (!prevState.isActive && this.state.isActive) {
      this.reviseHeight()
    }
  }

  reviseHeight() {
    if (window.innerHeight < MaxHeightSpace && this.state.isActive) {
      const newHeight = window.innerHeight - Margin * 2 - MoveButtonSize - MoveButtonMargin
      this.setState({ height: newHeight })
    }
  }

  moveToRight() {
    this.setState({ position: Position.Right })
  }

  moveToLeft() {
    this.setState({ position: Position.Left })
  }

  handleFloatWrapperMove () {
    switch (this.position) {
      case Position.Right:
        this.moveToLeft()
        break
      case Position.Left:
        this.moveToRight()
        break
    }
  }

  render() {
    const {
      token,
    } = this.props;

    const {
      isActive,
      isLoadingIframe,
      isLoadedIframe,
      isDeniedAccess,
      name,
      avatarURL,
      position,
      height
    } = this.state;

    if (isDeniedAccess) { return <span />; }

    const chatURL = `${Origin}/embed/${token}/chats?noheader=false`;
    const isShowIframe = isLoadingIframe || isLoadedIframe;

    return (
      <span>
        <FloatWrapper
          avatarURL={avatarURL}
          name={name}
          isActive={isActive}
          isDisableBorderRadius={true}
          position={position}
          onOpen={() => this.setState({ isActive: true, isLoadingIframe: true })}
          onClose={() => this.setState({ isActive: false })}
          onMove={this.handleFloatWrapperMove}
          innerRef={node => this.wrapper = node}
          height={height}
        >
          {isShowIframe && (
            <iframe
              src={chatURL}
              onLoad={this.onLoadIframe}
              scrolling="no"
              frameBorder="0"
              title="My-ope office"
              style={{ width: '100%', height: '100%' }}
              ref={(node) => this.iframe = node}
            />
          )}
          {isLoadingIframe && !isLoadedIframe && (
            <LoadingMessage>読み込み中。少々お待ち下さい...</LoadingMessage>
          )}
        </FloatWrapper>
      </span>
    )
  }

  onClickHeader() {
    this.setState({
      isActive: !this.state.isActive,
      isLoadingIframe: true,
    });
  }

  onLoadIframe() {
    this.setState({ isLoadingIframe: false, isLoadedIframe: true });
  }
}
