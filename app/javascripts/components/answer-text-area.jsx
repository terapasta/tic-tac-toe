import React, { Component, PropTypes } from "react";
import debounce from "lodash/debounce";
import isEmpty from "is-empty";
import uuid from 'uuid/v4';

import * as QuestionAnswerAPI from "../api/question-answer";

class SuggestWrapper extends Component {
  render() {
    const style = {
      overflowY: 'auto',
      position: 'absolute',
      top: 'calc(100% - 1px)',
      left: 0,
      right: 0,
      zIndex: 10,
      maxHeight: '200px',
      boxShadow: '0 2px 5px rgba(0,0,0,.2)',
      borderRadius: '0 0 0.25rem 0.25rem',
    }
    return (
      <div className="card" style={style}>{this.props.children}</div>
    )
  }
}

class SuggestItem extends Component {
  constructor(props) {
    super(props)
    this.state = { isHovered: false }
  }
  render() {
    const { isHovered } = this.state
    const style ={
      cursor: 'pointer',
      display: 'block',
      padding: '16px',
      borderTop: '1px solid #ccc',
      backgroundColor: isHovered ? '#efefef' : '#fff'
    }
    return (
      <div
        style={style}
        onMouseEnter={() => this.setState({ isHovered: true }) }
        onMouseLeave={() => this.setState({ isHovered: false }) }
      >{this.props.children}</div>
    )
  }
}

export default class AnswerTextArea extends Component {
  static get componentName() {
    return "AnswerTextArea";
  }

  static get propTypes() {
    return {
      baseName: PropTypes.string.isRequired,
      defaultValue: PropTypes.string,
      botId: PropTypes.number.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      text: props.defaultValue || "",
      answers: [],
    };

    this.onChangeTextArea = this.onChangeTextArea.bind(this);
    this.debouncedSearchAnswers = debounce(this.searchAnswers.bind(this), 250);
  }

  render() {
    const { baseName, botId } = this.props;
    const { text, answers } = this.state;

    return (
      <div className="form-group" style={{ position: 'relative' }}>
        <label>回答</label>
        <textArea className="form-control"
          ref={node => { this.textArea = node }}
          rows={5}
          onChange={this.onChangeTextArea}
          name={`${baseName}[answer]`}
        />
        {!isEmpty(text) && <input type="hidden" name={`${baseName}[bot_id]`} value={botId} />}
        {!isEmpty(answers) && (
          <SuggestWrapper>
            <label className="m-3">回答の候補</label>
            {answers.map(answer => (
              <SuggestItem
                key={uuid()}
                onClick={this.onClickAnswer.bind(this, answer)}
              >{answer}</SuggestItem>
            ))}
          </SuggestWrapper>
        )}
      </div>
    );
  }

  onChangeTextArea() {
    const { value } = this.textArea;
    // this.setState({ text: value });
    if (!isEmpty(value)) {
      this.debouncedSearchAnswers(value);
    } else {
      this.setState({ answers: [] });
    }
  }

  onClickAnswer(text) {
    this.textArea.value = text
    this.setState({ answers: [] })
  }

  searchAnswers(text) {
    const { botId } = this.props;
    QuestionAnswerAPI.findAll(botId, { q: text }).then((res) => {
      this.setState({ answers: res.data.questionAnswers.map(qa => qa.answer) });
    }).catch((err) => {
      console.error(err);
    });
  }
}
