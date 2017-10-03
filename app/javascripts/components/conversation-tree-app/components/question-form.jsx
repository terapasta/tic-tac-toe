import React, { Component, PropTypes } from 'react';
import TextArea from 'react-textarea-autosize';
import isEmpty from 'is-empty';

import Mixpanel, { makeEvent } from '../../../analytics/mixpanel';
import { activeItemType, questionsRepoType } from '../types';
import Modal from '../../modal';

class QuestionForm extends Component {
  constructor(props) {
    super(props);
    this.onSubmit = this.onSubmit.bind(this);
    this.onDelete = this.onDelete.bind(this);

    const { activeItem, questionsRepo } = props;
    if (isEmpty(activeItem.node)) {
      this.state = { question: '', answer: '' };
      return;
    }
    const question = questionsRepo[activeItem.node.id];
    this.state = {
      question: question.question,
      answer: question.answer,
      isShowConfirmDelete: false,
    };
  }

  componentWillReceiveProps(nextProps) {
    const { activeItem, questionsRepo } = nextProps;
    if (isEmpty(activeItem.node)) {
      this.state = { question: '', answer: '' };
      return;
    }
    const question = questionsRepo[activeItem.node.id];
    if (question == null) { return; }
    this.setState({
      question: question.question,
      answer: question.answer || '',
    });
  }

  onSubmit() {
    const { activeItem, onCreate, onUpdate } = this.props;
    const { question, answer } = this.state;
    if (isEmpty(activeItem.node)) {
      onCreate(question, answer);
    } else {
      onUpdate(activeItem.node.id, question, answer);
    }
    const { eventName, options } = makeEvent('tree save q&a');
    Mixpanel.sharedInstance.trackEvent(eventName, options);
  }

  onDelete() {
    const { activeItem, onDelete } = this.props;
    onDelete(activeItem.node.id);
    const { eventName, options } = makeEvent('tree delete q&a');
    Mixpanel.sharedInstance.trackEvent(eventName, options);
  }

  render() {
    const { activeItem } = this.props;
    const { question, answer, isShowConfirmDelete } = this.state;

    return (
      <div>
        <div className="form-group" id={`question-form-${question.id}`}>
          <label><i className="material-icons valign-middle">comment</i>{" "}質問</label>
          <TextArea
            id="question"
            name="question-question"
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
            name="question-answer"
            rows={3}
            onChange={e => this.setState({ answer: e.target.value })}
            value={answer}
          />
        </div>

        <div className="form-group clearfix">
          <div className="text-right">
            <a className="btn btn-success"
              id="save-answer-button"
              href="#"
              onClick={this.onSubmit}
              disabled={false}
            >保存</a>

            {activeItem.node !== null && (
              <span>
                &nbsp;&nbsp;
                <a className="btn btn-link"
                  id="delete-answer-button"
                  href="#"
                  onClick={() => this.setState({ isShowConfirmDelete: true })}
                  disabled={false}
                ><span className="text-danger">削除</span></a>
              </span>
            )}
          </div>
        </div>
        {isShowConfirmDelete && (
          <Modal
            title="本当に削除してよろしいですか？"
            onClose={() => this.setState({ isShowConfirmDelete: false })}
            narrow
          >
            <div className="text-right">
              <button
                className="btn btn-default"
                onClick={() => this.setState({ isShowConfirmDelete: false })}
                id="alert-cancel-button"
              >キャンセル</button>
              &nbsp;
              <button
                className="btn btn-danger"
                onClick={this.onDelete}
                id="alert-delete-button"
              >削除する</button>
            </div>
          </Modal>
        )}
      </div>
    );
  }
}

QuestionForm.propTypes = {
  activeItem: activeItemType,
  questionsRepo: questionsRepoType.isRequired,
  onCreate: PropTypes.func.isRequired,
  onUpdate: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
};

export default QuestionForm;