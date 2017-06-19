import React, { Component, PropTypes } from "react";
import isEmpty from "is-empty";

import ChatContainer from "./container";
import Modal from "../modal";

export default class ChatInitialQuestion extends Component {
  static get propTypes() {
    return {
      isManager: PropTypes.bool,
      isFirst: PropTypes.bool,
      initialQuestions: PropTypes.array.isRequired,
      onChange: PropTypes.func.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      isAppearDesc: false,
      isAppearSelector: false,
    };

    this.basePath = `/bots/${window.currentBot.id}/question_answers/selections`;
    this.iframePath = `${this.basePath}?headless=true&hide_page_header=true`;
    this.closeSelector = this.closeSelector.bind(this);
  }

  render() {
    const {
      isManager,
      isFirst,
    } = this.props;

    return (
      <ChatContainer>
        {isManager && isFirst && (
          <div style={{marginTop:"32px"}}>
            {this.renderEmptyMessage()}
            {this.renderDesc()}
            {this.renderSelector()}
          </div>
        )}
      </ChatContainer>
    );
  }

  renderEmptyMessage() {
    const { initialQuestions } = this.props;
    const isEmptyInitQs = isEmpty(initialQuestions);

    return (
      <span>
        {isEmptyInitQs && (
          <span>
            <p className="text-muted" style={{borderBottom:"1px solid #ccc", paddingBottom:"8px"}}>チャットボット管理者の方へ</p>
            <h4>チャットに初期質問リストを表示できます</h4>
          </span>
        )}
        <p>
          <button className="btn btn-default"
            onClick={() => this.setState({ isAppearSelector: true })}>
            <i className="material-icons">playlist_add_check</i>
            {" "}
            <span>初期質問リストを選択する</span>
          </button>
        </p>
        <p>
          <a href="#" onClick={() => { this.setState({ isAppearDesc: true }); }}>
            <i className="material-icons" style={{fontSize:"18px"}}>help</i>
            {" "}
            初期質問リストとは
          </a>
        </p>
      </span>
    );
  }

  renderDesc() {
    if (!this.state.isAppearDesc) { return null; }
    return (
      <Modal title="初期質問リストとは"
             onClose={() => this.setState({ isAppearDesc: false })}>
        <p>チャットを開始後すぐの画面に、任意の質問候補を最大で５つまで表示できる機能です。</p>
        <p>[スクショが入る]</p>
        <p>時期によって質問内容が予想される場合等に設定しておくと効果的です。</p>
      </Modal>
    );
  }

  renderSelector() {
    if (!this.state.isAppearSelector) { return null; }

    return (
      <Modal title="初期質問を選択"
        onClose={this.closeSelector}
        iframeUrl={this.iframePath}
        wide
      />
    );
  }

  closeSelector() {
    this.setState({ isAppearSelector: false });
    this.props.onChange();
  }
}
