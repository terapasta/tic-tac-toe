import React, { Component, PropTypes, createElement } from "react";
import styled from "styled-components";
import classNames from "classnames";

import ArrowSVG from "./arrow-svg";
import LogoSVG from "./logo-svg";

import {
  Wrapper,
  LeftWrapper,
  Header,
  Arrow,
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
      isLoadedIframe: false
    };
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
    } = this.state;

    const activeClassName = classNames({
      active: isActive,
    });

    const chatURL = `${Origin}/embed/${token}/chats`;

    const result = (
      <span>
        <Header onClick={this.onClickHeader.bind(this)}>
          <Arrow className={activeClassName}>
            <ArrowSVG />
          </Arrow>
          <Logo className={activeClassName}>
            <LogoSVG />
          </Logo>
        </Header>
        <IframeContainer>
          {(isLoadingIframe || isLoadedIframe) && (
            <Iframe src={chatURL} onLoad={this.onLoadIframe.bind(this)} />
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
