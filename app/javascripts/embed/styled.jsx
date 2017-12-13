import React from "react";
import styled from "styled-components";

import {
  MobileMaxWidth,
  Position,
  MaxHeight,
  Margin,
  MoveButtonSize,
  MoveButtonMargin
} from "./constants";

const OrangeColor = '#F36B30'
const handleClickBy = func => ((e) => {
  e.preventDefault()
  e.stopPropagation()
  func()
})

export const FloatWrapper = props => (
  <FloatWrapperBase
    position={props.position}
    onClick={handleClickBy(props.onOpen)}
    isActive={props.isActive}
    height={props.height}
  >
    <MoveButton isActive={props.isActive} onClick={handleClickBy(props.onMove)}>
      {props.position === 'left' ? '右へ移動' : '左へ移動'}
    </MoveButton>
    <FloatInner isActive={props.isActive} height={props.height}>
      <FloatButtonLabel>
        チャットを開く
      </FloatButtonLabel>
      <FloatButtonAvatar isActive={props.isActive} avatarURL={props.avatarURL} />
      {props.isActive && (
        <CloseButton onClick={handleClickBy(props.onClose)}>&times;</CloseButton>
      )}
      {props.children}
    </FloatInner>
  </FloatWrapperBase>
)

const ActiveSize = {
  Width: 300,
  Height: MaxHeight
}
const transition = 'transition: all 0.15s;'
const lightShadow = `
  box-shadow: 0 24px 38px 3px rgba(0,0,0,0.08),
              0 9px 46px 8px rgba(0,0,0,0.06),
              0 11px 15px -7px rgba(0,0,0,0.1);
`
const darkShadow = `
  box-shadow: 0 24px 38px 3px rgba(0,0,0,0.14),
              0 9px 46px 8px rgba(0,0,0,0.12),
              0 11px 15px -7px rgba(0,0,0,0.2);
`

const MoveButton = styled.a.attrs({
  'data-name': 'MoveButton'
})`
  ${transition}
  ${lightShadow}
  display: inline-block;
  opacity: 0;
  margin: 0 auto ${MoveButtonMargin}px;
  padding: 0 8px;
  // width: ${MoveButtonSize}px;
  height: ${MoveButtonSize}px;
  border-radius: ${MoveButtonSize / 2}px;
  background-color: #fff;
  text-align: center;
  color: #444;
  line-height: ${MoveButtonSize + 1}px;
  font-size: 12px;
  &:hover {
    color: #444;
    text-decoration: none;
    background-color: #ddd;
  }

  @media (max-width: ${MobileMaxWidth}px) {
    ${props => props.isActive && `
      display: none;
    `}
  }
`

const FloatButtonAvatar = styled.div`
  position: relative;
  z-index: 101;
  transition-property: all;
  transition-duration: 0.25s;
  width: 64px;
  height: 64px;
  // border: 2px solid #ccc;
  border: 2px solid #fff;
  border-radius: 32px;
  background-image: url(${props => props.avatarURL});
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
  background-color: #fff;

  ${props => props.isActive && `
    display: none;
  `}
`

const FloatWrapperBase = styled.div.attrs({
  'data-name': 'FloatButtonWrapper'
})`
  transition: all 0.25s;
  opacity: 1;
  cursor: pointer;
  position: fixed;
  ${props => props.position === Position.Left && `
    left: ${Margin}px;
    right: auto;
  `}
  ${props => props.position === Position.Right && `
    left: auto;
    right: ${Margin}px;
  `}
  bottom: ${Margin + 10}px;
  z-index: 99995000;
  height: 84px;
  text-align: center;

  &:hover [data-name=FloatInner] {
    width: 165px;
  }
  &:hover [data-name=MoveButton] {
    opacity: 1;
  }

  ${props => props.isActive && `
    @media (min-width: ${MobileMaxWidth + 1}px) {
      bottom: ${Margin}px;
      width: ${ActiveSize.Width}px !important;
      height: ${props.height + MoveButtonSize + MoveButtonMargin}px !important;
    }
    @media (max-width: ${MobileMaxWidth}px) {
      left: auto;
      right: 0;
      bottom: 0;
      width: 100% !important;
      height: 100% !important;
    }
  `}
`
const FloatInner = styled.div.attrs({
  'data-name': 'FloatInner'
})`
  ${transition}
  position: relative;
  overflow: hidden;
  width: 64px;
  height: 64px;
  border-radius: 32px;
  background-color: #fff;
  ${lightShadow}

  ${props => props.isActive && `
    border-radius: 16px;
    cursor: default;
    @media (min-width: ${MobileMaxWidth + 1}px) {
      width: ${ActiveSize.Width}px !important;
      height: ${props.height}px !important;
    }
    @media (max-width: ${MobileMaxWidth}px) {
      right: 0;
      bottom: 0;
      width: 100% !important;
      height: 100% !important;
      border-radius: 0;
    }

    [data-name=FloatButtonLabel] {
      display: none;
    }
    ${darkShadow}
  `}
`

const FloatButtonLabel = styled.div.attrs({
  'data-name': 'FloatButtonLabel'
})`
  position: absolute;
  top: 50%;
  right: 12px;
  z-index: 100;
  transform: translateY(-50%);
  width: 85px;
  color: ${OrangeColor};
  font-size: 12px;
  font-weight: bold;
  line-height: 18px;
  letter-spacing:0;
`

const OneLineText = styled.div`
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
`
const CloseButton = styled.a.attrs({
  href: '#'
})`
  position: absolute;
  top: 8px;
  right: 8px;
  display: block;
  width: 32px;
  height: 32px;
  color: #ccc;
  font-size: 42px;
  line-height: 0.85;
  text-align: center;

  &:hover {
    text-decoration: none;
    color: #aaa;
  }
`

export const LoadingMessage = styled.div`
  position: absolute;
  top: 50%;
  left: 16px;
  right: 16px;
  transform: translateY(-50%);
  text-align: center;
  color: #999;
`;
