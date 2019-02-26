import React, { Component, PropTypes } from "react";
import classNames from "classnames";
import uuid from "uuid/v1";

import Mixpanel, { makeEvent } from '../analytics/mixpanel';

export default class BotResetForm extends Component {
  static get componentName() {
    return "BotResetForm";
  }

  static get propTypes() {
    return {
      url: PropTypes.string.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      isValidUnlockCode: false,
      unlockCode: makeUnlockCode(),
      userInputUnlockCode: "",
    };
  }

  render() {
    const {
      isValidUnlockCode,
      unlockCode,
      userInputUnlockCode,
    } = this.state;

    return (
      <span>
        <h5>学習データをリセットすると以下のデータが全て削除されます</h5>
        <ul>
          <li>Q&amp;Aデータ</li>
          <li>対話履歴</li>
        </ul>
        <p>本当にリセットしてもよろしければ以下のフォームに<br />
        <strong>解除コード</strong>を入力してリセットボタンを押してください</p>
        <p>
          解除コード：<code>{unlockCode}</code>
        </p>
        <div className="form-group">
          <input type="text" className="form-control"
            value={userInputUnlockCode}
            onKeyDown={this.onKeyDownUnlockCode.bind(this)}
            onChange={this.onChangeUnlockCode.bind(this)}/>
        </div>
        <div className="form-group">
          <a href="#" className="btn btn-danger"
            disabled={!isValidUnlockCode}
            onClick={this.onClickSubmitButton.bind(this)}>
            学習データをリセット</a>
        </div>
      </span>
    );
  }

  onClickResetButton(e) {
    e.preventDefault();
    this.setState({
      unlockCode: makeUnlockCode(),
    });
  }

  onKeyDownUnlockCode(e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      e.stopPropagation();
    }
  }

  onChangeUnlockCode(e) {
    const { unlockCode } = this.state;
    const { value } = e.target;
    this.setState({
      isValidUnlockCode: value === unlockCode,
      userInputUnlockCode: value,
    });
  }

  onClickSubmitButton(e) {
    e.preventDefault();
    const { eventName, options } = makeEvent('to all reset');
    Mixpanel.sharedInstance.trackEvent(eventName, options);

    const { url } = this.props;
    const { isValidUnlockCode } = this.state;
    if (!isValidUnlockCode) { return; }
    if (window.$.rails == null) { return; }
    const link = makeDummyLink(url);
    window.$.rails.handleMethod(link);
  }
}

function makeUnlockCode() {
  return uuid().slice(0, 6);
}

function makeDummyLink(url) {
  const a = document.createElement("a");
  a.href = url;
  a.setAttribute("data-method", "post");
  return window.$(a);
}
