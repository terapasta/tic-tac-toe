import React, { Component, PropTypes } from 'react';
import TextArea from 'react-textarea-autosize';
import isEmpty from 'is-empty';

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
    };
  }

  componentWillReceiveProps(nextProps) {
    const { answer, decisionBranches } = this.constructor.getAnswerAndDecisionBranches(nextProps);
    this.setState({ answer, decisionBranches });
  }

  onCreateDecisionBranch(body) {
    return this.constructor.onCreateDecisionBranch(this.props, body);
  }

  onUpdateDecisionBranch(id, body) {
    return this.constructor.onUpdateDecisionBranch(this.props, id, body);
  }

  onDeleteDeicsionBranch(id) {
    return this.constructor.onDeleteDecisionBranch(this.props, id);
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
                  onDelete={() => this.onDeleteDeicsionBranch(db.id)}
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
    const { answer } = this.state;

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
              onClick={() => {}}
              disabled={false}>保存</a>
          </div>
        </div>

        {this.renderDecisionBranches()}

        <div className="form-group">
          <NewDecisionBranchForm
            onSave={(body) => this.onCreateDecisionBranch(body)}
          />
        </div>
      </div>
    );
  }
}

export default BaseAnswerForm;
