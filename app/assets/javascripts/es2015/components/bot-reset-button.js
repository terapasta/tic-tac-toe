import React, { Component, PropTypes } from "react";
import classNames from "classnames";
import uuid from "uuid/v1";

export default class BotResetButton extends Component {
  static get componentName() {
    return "BotResetButton";
  }

  static get propTypes() {
    return {
      url: PropTypes.string.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      isOpenedModal: false,
      isValidUnlockCode: false,
      unlockCode: null,
      userInputUnlockCode: "",
    };
  }

  render() {
    const {
      isOpenedModal,
      isValidUnlockCode,
      unlockCode,
      userInputUnlockCode,
    } = this.state;

    const modalClassName = classNames("modal fade", {
      in: isOpenedModal,
    });
    const modalStyle = { display: isOpenedModal ? "block" : "none" };

    return (
      <span>
        <a href="#" className="btn btn-danger"
          onClick={this.onClickResetButton.bind(this)}>
          学習データリセット
        </a>

        {isOpenedModal && <div className="modal-backdrop fade in" />}

        <div className={modalClassName}
          style={modalStyle}
          onClick={this.onClickModalClose.bind(this)}>
          <div className="modal-dialog" onClick={(e) => e.stopPropagation()}>
            <div className="modal-content">
              <div className="modal-header">
                <a href="#" className="close" onClick={this.onClickModalClose.bind(this)}>&times;</a>
                <h5 className="modal-title">学習データリセットの確認</h5>
              </div>
              <div className="modal-body">
                <p>学習データをリセットすると以下のデータが全て削除されます</p>
                <ul>
                  <li>学習データ</li>
                  <li>回答データ</li>
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
              </div>
            </div>
          </div>
        </div>
      </span>
    );
  }

  onClickResetButton(e) {
    e.preventDefault();
    this.setState({
      isOpenedModal: true,
      unlockCode: makeUnlockCode(),
    });
  }

  onClickModalClose(e) {
    e.preventDefault();
    this.setState({
      isOpenedModal: false,
      isValidUnlockCode: false,
      userInputUnlockCode: "",
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
