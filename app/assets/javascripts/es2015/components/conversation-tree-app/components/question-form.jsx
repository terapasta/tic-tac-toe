import React, { Component, PropTypes } from 'react';
import TextArea from "react-textarea-autosize";

import { activeItemType, questionsRepoType } from '../types';

class QuestionForm extends Component {
  constructor(props) {
    super(props);
    const { activeItem, questionsRepo } = props;
    const question = questionsRepo[activeItem.node.id];
    this.state = {
      question: question.question,
      answer: question.answer,
    };
  }

  componentWillReceiveProps(nextProps) {
    const { activeItem, questionsRepo } = nextProps;
    const question = questionsRepo[activeItem.node.id];
    this.setState({
      question: question.question,
      answer: question.answer,
    });
  }

  render() {
    const { question, answer } = this.state;

    return (
      <div>
        <div className="form-group" id={`question-form-${question.id}`}>
          <label><i className="material-icons valign-middle">comment</i>{" "}質問</label>
          <TextArea
            id="question"
            className="form-control"
            rows={3}
            placeholder="質問を入力してください（例：カードキー無くしてしまったのですが、どうすればいいですか）"
            onChange={e => this.setState({ question: e.target.value })}
            value={question}
          />
        </div>

        <div className="form-group">
          <label><i className="material-icons valign-middle">chat_bubble_outline</i>{" "}回答</label>
          <TextArea className="form-control"
            id="answer-body"
            name="answer-body"
            rows={3}
            onChange={e => this.setState({ answer: e.target.value })}
            value={answer}
          />
        </div>

        <div className="form-group clearfix">
          <div className="pull-right">
            <a className="btn btn-success"
              id="save-answer-button"
              href="#"
              onClick={() => {}}
              disabled={false}>保存</a>
          </div>
        </div>
      </div>
    );
  }
}

QuestionForm.propTypes = {
  activeItem: activeItemType,
  questionsRepo: questionsRepoType.isRequired,
};

export default QuestionForm;
