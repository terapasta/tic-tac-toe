import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";

import Question from "../../models/question";

class QuestionForm extends Component {
  render() {
    const {
      editingQuestionModel,
      isProcessing,
      answerBody,
      question,
      onChangeQuestion,
      onChangeAnswerBody,
      onClickSaveQuestionButton,
      onClickDeleteQuestionButton,
    } = this.props;
    if (editingQuestionModel == null) { return null; }

    return (
      <div className="form-group">
        <div className="form-group">
          <label><i className="material-icons valign-middle">comment</i>{" "}質問</label>
          <TextArea className="form-control"
            name="question-question"
            rows={3}
            value={question || ""}
            onChange={onChangeQuestion}
            disabled={isProcessing}
          />
        </div>
        <div className="form-group">
          <label><i className="material-icons valign-middle">chat_bubble_outline</i>{" "}対応する回答</label>
          <TextArea className="form-control"
            name="answer-body"
            rows={3}
            value={answerBody || ""}
            onChange={onChangeAnswerBody}
            disabled={isProcessing}
          />
          <div className="help-block clearfix">
            <div className="pull-right">
              <a className="btn btn-primary" href="#"
                id="save-question"
                onClick={onClickSaveQuestionButton}
                disabled={isProcessing}>保存</a>
              {" "}
              <span className="btn btn-danger"
                onClick={onClickDeleteQuestionButton}
                id="delete-question">削除</span>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

QuestionForm.propTypes = {
  editingQuestionModel: PropTypes.instanceOf(Question),
  isProcessing: PropTypes.bool.isRequired,
  answerBody: PropTypes.string,
  question: PropTypes.string,
  onChangeQuestion: PropTypes.func.isRequired,
  onChangeAnswerBody: PropTypes.func.isRequired,
  onClickSaveQuestionButton: PropTypes.func.isRequired,
  onClickDeleteQuestionButton: PropTypes.func.isRequired,
};

export default QuestionForm;
