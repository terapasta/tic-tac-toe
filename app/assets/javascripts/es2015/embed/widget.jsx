import React, { Component, PropTypes, createElement } from "react";
import styled from "styled-components";
import classNames from "classnames";
import get from "lodash/get";

import * as PublicBotAPI from '../api/public_bot';

import ArrowSVG from "./arrow-svg";
import LogoSVG from "./logo-svg";

import {
  HeaderHeight,
} from './constants';

import {
  Wrapper,
  LeftWrapper,
  Header,
  Arrow,
  Avatar,
  DummyInput,
  StatusLabel,
  Logo,
  IframeContainer,
  Iframe,
  Loading,
  LoadingMessage
} from "./styled";

const Origin = process.env.NODE_ENV === "development" ?
  "http://donusagi-bot.dev" : "https://app.my-ope.net";

export default class Widget extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isActive: false,
      isLoadingIframe: false,
      isLoadedIframe: false,
      isDeniedAccess: true,
    };

    this.fetchPulicBot(props.token);
  }

  fetchPulicBot(token) {
    PublicBotAPI.find(token, { origin: Origin }).then((res) => {
      this.setState({
        name: get(res, "data.bot.name"),
        avatarURL: get(res, "data.bot.image.thumb.url"),
        isDeniedAccess: false,
      });
    }).catch(console.error);
  }

  render() {
    const {
      position,
      token,
    } = this.props;

    const {
      isActive,
      isLoadingIframe,
      isLoadedIframe,
      isDeniedAccess,
      name,
      avatarURL,
    } = this.state;

    if (isDeniedAccess) { return <span />; }

    const activeClassName = classNames({
      active: isActive,
    });

    const chatURL = `${Origin}/embed/${token}/chats`;

    const isShowIframe = isLoadingIframe || isLoadedIframe;

    const result = (
      <span>
        <Header onClick={this.onClickHeader.bind(this)}>
          <Avatar alt={name} style={{ backgroundImage: `url(${avatarURL})` }} />
          {!isActive && (
            <DummyInput>ご質問にお答えします</DummyInput>
          )}
          {isActive && (
            <StatusLabel>AIチャットボットがご対応します</StatusLabel>
          )}
          <Arrow className={activeClassName}>
            <ArrowSVG />
          </Arrow>
          <Logo className={activeClassName}>
            <LogoSVG />
          </Logo>
        </Header>
        <IframeContainer>
          {isShowIframe && (
            <iframe
              src={chatURL}
              onLoad={this.onLoadIframe.bind(this)}
              scrolling="no"
              title="My-ope office"
              style={{
                width: `${window.innerWidth}px`,
                height: `${window.innerHeight - HeaderHeight}px`,
              }}
            />
          )}
          {isLoadingIframe && !isLoadedIframe && (
            <Loading>
              <LoadingMessage>読み込み中。少々お待ち下さい...</LoadingMessage>
            </Loading>
          )}
        </IframeContainer>
      </span>
    );

    const wrapperComponent = position === "left" ? LeftWrapper : Wrapper;
    return createElement(wrapperComponent, {
      className: activeClassName,
    }, result);
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
