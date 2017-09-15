import React, { Component } from 'react';
import classnames from 'classnames';

export const Wrapper = (props) => (
  <div className="dict">
    {props.children}
  </div>
);

export const Title = (props) => {
  const classNames = classnames('dict__title', {
    editing: !!props.editing,
  });

  return (
    <div className={classNames}>
      {props.children}
    </div>
  );
};

export const SubTitle = (props) => (
  <div className="dict__subtitle">
    {props.children}
  </div>
);

export const Words = (props) => (
  <ul className="dict__words">
    {props.children}
  </ul>
);

export const Word = (props) => {
  const classNames = classnames('dict__word', {
    'no-border': !!props.noBorder,
    'no-padding': !!props.noPadding,
  });

  return (
    <li
      className={classNames}
      onClick={props.onClick}
    >
      {props.children}
    </li>
  );
};

export const HelpText = (props) => (
  <div className="dict__help-text">
    {props.children}
  </div>
);

export const EnterToSaveText = () => (
  <HelpText>
    <small>
      <i className="material-icons">keyboard_return</i>
      &nbsp;エンターキーで保存します
    </small>
  </HelpText>
);

export class Input extends Component {
  render() {
    return (
      <input
        className="dict__input"
        ref={this.props.innerRef}
        {...this.props}
      />
    );
  }
}
