import React, { Component, PropTypes } from "react";
import debounce from "lodash/debounce";
import isEmpty from "is-empty";

import * as AnswerAPI from "../api/answer";
import Panel from "./panel";

export default class AnswerBodyTextArea extends Component {
  static get componentName() {
    return "AnswerBodyTextArea";
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
      <div className="form-group">
        <label>回答</label>
        <textArea className="form-control"
          rows={5}
          onChange={this.onChangeTextArea}
          value={text}
          name={`${baseName}[body]`}
        />
        {!isEmpty(text) && <input type="hidden" name={`${baseName}[bot_id]`} value={botId} />} 
        {!isEmpty(answers) && (
          <div className="well">
            <h4>回答の候補</h4>
            {answers.map((answer, i) => {
              return (
                <Panel key={i} isClickable={true} onClickBody={this.onClickAnswer.bind(this, answer.body)}>
                  {answer.body}
                </Panel>
              );
            })}
          </div>
        )}
      </div>
    );
  }

  onChangeTextArea(e) {
    const { value } = e.target;
    this.setState({ text: value });
    if (!isEmpty(value)) {
      this.debouncedSearchAnswers(value);
    } else {
      this.setState({ answers: [] });
    }
  }

  onClickAnswer(text) {
    this.setState({ text, answers: [] });
  }

  searchAnswers(text) {
    const { botId } = this.props;
    AnswerAPI.findAll(botId, { q: text }).then((res) => {
      this.setState({ answers: res.data.answers });
    }).catch((err) => {
      console.error(err);
    });
  }
}
