import React, { Component, PropTypes } from 'react';
import TextArea from 'react-textarea-autosize';
import isEmpty from 'is-empty';

import Modal from '../../modal';
import EditingDecisionBranchForm from './editing-decision-branch-form';
import NewDecisionBranchForm from './new-decision-branch-form';
import DecisionBranchItem from './decision-branch-item';

class BaseAnswerForm extends Component {
  constructor(props) {
    super(props);
    const { answer, decisionBranches } = this.constructor.getAnswerAndDecisionBranches(props);
    this.state = {
      answer,
      decisionBranches,
      editingDecisionBranchIndex: null,
      isShowConfirmDelete: false,
    };
  }

  componentWillReceiveProps(nextProps) {
    const { answer, decisionBranches } = this.constructor.getAnswerAndDecisionBranches(nextProps);
    this.setState({ answer, decisionBranches });
  }

  onUpdateAnswer(answer) {
    return this.constructor.onUpdateAnswer(this.props, answer);
  }

  onDeleteAnswer() {
    return this.constructor.onDeleteAnswer(this.props);
  }

  onCreateDecisionBranch(body) {
    return this.constructor.onCreateDecisionBranch(this.props, body);
  }

  onUpdateDecisionBranch(id, body) {
    return this.constructor.onUpdateDecisionBranch(this.props, id, body);
  }

  onDeleteDecisionBranch(id) {
    return this.constructor.onDeleteDecisionBranch(this.props, id);
  }

  onClickDeleteCommon() {
    const { deleteType, deletingDecisionBranchId } = this.state;

    switch (deleteType) {
      case 'answer':
        this.onDeleteAnswer();
        break;
      case 'decisionBranch':
        this.onDeleteDecisionBranch(deletingDecisionBranchId);
        break;
      default:
        break;
    }
    this.setState({
      isShowConfirmDelete: false,
      deleteType: null,
      deletingDecisionBranchId: null,
    });
  }

  renderDecisionBranches() {
    const { decisionBranches, editingDecisionBranchIndex } = this.state;
    if (isEmpty(decisionBranches)) { return null; }

    return (
      <div className="form-group">
        <ul className="list-group margin-bottom-8">
          {decisionBranches.map((db, i) => {
            if (db == null) { return null; }
            if (editingDecisionBranchIndex === i) {
              return (
                <EditingDecisionBranchForm
                  key={db.id}
                  decisionBranch={db}
                  onSave={(body) => {
                    this.onUpdateDecisionBranch(db.id, body).then(() => {
                      this.setState({ editingDecisionBranchIndex: null });
                    });
                  }}
                  onDelete={() => this.setState({ isShowConfirmDelete: true, deleteType: 'decisionBranch', deletingDecisionBranchId: db.id })}
                />
              );
            } else {
              return (
                <DecisionBranchItem
                  key={db.id}
                  decisionBranch={db}
                  onClick={() => this.setState({ editingDecisionBranchIndex: i })}
                />
              );
            }
          })}
        </ul>
      </div>
    );
  }

  render() {
    const { answer, isShowConfirmDelete } = this.state;

    return (
      <div>
        <div className="form-group">
          <label><i className="material-icons valign-middle">chat_bubble_outline</i>{" "}回答</label>
          <TextArea className="form-control"
            id="answer-body"
            name="answer-body"
            rows={3}
            value={answer}
            onChange={e => this.setState({ answer: e.target.value })}
            disabled={false} />
        </div>

        <div className="form-group clearfix">
          <div className="pull-right">
            <a className="btn btn-success"
              id="save-answer-button"
              href="#"
              onClick={() => this.onUpdateAnswer(answer)}
              disabled={false}>保存</a>

            &nbsp;&nbsp;
            <a className="btn btn-link"
              id="delete-answer-button"
              href="#"
              onClick={() => this.setState({ isShowConfirmDelete: true, deleteType: 'answer' })}
              disabled={false}
            ><span className="text-danger">削除</span></a>
          </div>
        </div>

        {this.renderDecisionBranches()}

        <div className="form-group">
          <NewDecisionBranchForm
            onSave={(body) => this.onCreateDecisionBranch(body)}
          />
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
                onClick={() => this.onClickDeleteCommon()}
                id="alert-delete-button"
              >削除</button>
            </div>
          </Modal>
        )}
      </div>
    );
  }
}

export default BaseAnswerForm;
