import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";
import get from "lodash/get";

export default class AnswerForm extends Component {
  static get propTypes() {
    return {
      activeItem: PropTypes.object,
      editingAnswerModel: PropTypes.object,
      isProcessing: PropTypes.bool.isRequired,
      answerBody: PropTypes.string,
      onChange: PropTypes.func.isRequired,
      onSave: PropTypes.func.isRequired,
      onDelete: PropTypes.func.isRequired,
    };
  }

  render() {
    const {
      activeItem,
      editingAnswerModel,
      answerBody,
      isProcessing,
      onChange,
      onSave,
      onDelete,
    } = this.props;

    const dataType = get(activeItem, "dataType");

    if ((dataType != "answer" && dataType != "decisionBranch") ||
        editingAnswerModel == null) {
      return null;
    }

    return (
      <div className="form-group">
        <label><i className="material-icons valign-middle">chat_bubble_outline</i>{" "}回答</label>
        <TextArea className="form-control"
          id="answer-body"
          name="answer-body"
          rows={3}
          value={answerBody || ""}
          onChange={onChange}
          disabled={isProcessing} />
        <div className="help-block clearfix">
          <div className="pull-right">
            <a className="btn btn-primary"
              id="save-answer-button"
              href="#"
              onClick={onSave}
              disabled={isProcessing}>保存</a>
            {" "}
            {editingAnswerModel.id != null && (
              <span className="btn btn-danger"
                onClick={onDelete}
                id="delete-answer-button">削除</span>
            )}
          </div>
        </div>
      </div>
    );
  }
}
