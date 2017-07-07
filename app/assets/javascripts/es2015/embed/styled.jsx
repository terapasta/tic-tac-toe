import React from "react";
import styled from "styled-components";

import {
  Width,
  Height,
  HeaderHeight,
  HeaderBGColor,
  HeaderBGColorHover,
  HiddenBottomValue,
  Margin,
  MobileMaxWidth,
  WidthMobileHidden,
} from "./constants";

export const Wrapper = styled.div`
  overflow: hidden;
  position: fixed;
  bottom: -${HiddenBottomValue}px;
  right: ${Margin}px;
  height: ${Height}px;
  z-index: 5000;
  border-radius: 3px 3px 0 0;
  background-color: #fff;
  box-shadow: 0 2px 6px rgba(0,0,0,.5);
  transition-property: bottom, margin;
  transition-duration: .25s;
  margin: 0;
  padding: 0;
  font-size: 13px;

  &.active {
    bottom: 0;
  }

  @media (max-width: ${MobileMaxWidth}px) {
    width: ${WidthMobileHidden}px;

    &.active {
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      width: 100%;
      height: 100%;
    }
  }

  @media (min-width: ${MobileMaxWidth + 1}px) {
    width: ${Width}px;
  }
`;

export const LeftWrapper = styled(Wrapper)`
  right: auto;
  left: ${Margin}px;
`;

export const Header = styled.div`
  height: ${HeaderHeight}px;
  background-color: ${HeaderBGColor};
  position: relative;
  top: 0;
  left: 0;
  right: 0;
  cursor: pointer;

  &:hover {
    background-color: ${HeaderBGColorHover};
  }
`;

export const Arrow = styled.div`
  position: absolute;
  top: 12px;
  right: 13px;

  transform: rotate(0deg);

  &.active {
    transform: rotate(180deg);

    svg {
      vertical-align: bottom;
    }
  }

  svg {
    vertical-align: top;
  }
`;

export const Logo = styled.div`
  position: absolute;
  top: 8px;
  left: 8px;

  @media(max-width: ${MobileMaxWidth}px) {
    display: none;

    &.active {
      display: block;
    }
  }

  svg {
    vertical-align: top;
  }
`;


export const IframeContainer = styled.div`
  position: absolute;
  top: ${HeaderHeight}px;
  left: 0;
  right: 0;
  bottom: 0;
`;

export const Iframe = styled.iframe`
  display: block;
  border: 0;
  height: ${Height - HeaderHeight}px;
  width: 100%;

  @media (max-width: ${MobileMaxWidth}px) {
    height: 100%;
  }
`;

export const Loading = styled.div`
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
`;

export const LoadingMessage = styled.div`
  position: absolute;
  top: 50%;
  left: 16px;
  right: 16px;
  transform: translateY(-50%);
  text-align: center;
`;
