import React, { Component, PropTypes } from 'react';
import TextArea from 'react-textarea-autosize';
import includes from 'lodash/includes';
import find from 'lodash/find';
import map from 'lodash/map';
import isEmpty from 'is-empty';

import {
  activeItemType,
  questionsTreeType,
  decisionBranchesRepoType,
} from '../types';

const getBodyAndAnswer = (props) => {
  const { activeItem, decisionBranchesRepo } = props;
  const decisionBranch = decisionBranchesRepo[activeItem.node.id];
  if (decisionBranch == null) { return {}; }
  const { body, answer } = decisionBranch;
  return { body, answer: (answer || '') };
};

class DecisionBranchForm extends Component {
  constructor(props) {
    super(props);
    this.onSubmit = this.onSubmit.bind(this);
    this.onDelete = this.onDelete.bind(this);

    const { body, answer } = getBodyAndAnswer(props);
    if (isEmpty(body) || isEmpty(answer)) {
      this.state = { body: '', answer: '', disabled: false };
      return;
    }
    this.state = {
      body,
      answer,
      disabled: false,
    };
  }

  componentWillReceiveProps(nextProps) {
    const { body, answer } = getBodyAndAnswer(nextProps);
    if (isEmpty(body) || isEmpty(answer)) {
      this.state = { body: '', answer: '', disabled: false };
      return;
    }
    this.setState({ body, answer });
  }

  onSubmit() {
    if (this.state.disabled) { return; }
    this.setState({ disabled: true });

    const { body, answer } = this.state;
    const { activeItem, questionsTree, onUpdate } = this.props;
    const { id } = activeItem.node;
    const question = find(questionsTree, node => (
      includes(map(node.decisionBranches, 'id'), id))
    );
    onUpdate(question.id, id, body, answer).then(() => {
      this.setState({ disabled: false });
    });
  }

  onDelete() {
    if (this.state.disabled) { return; }
    this.setState({ disabled: true });

    const { activeItem, questionsTree, onDelete } = this.props;
    const { id } = activeItem.node;
    const question = find(questionsTree, node => (
      includes(map(node.decisionBranches, 'id'), id))
    );
    return onDelete(question.id, id);
  }

  render() {
    const { answer, body } = this.state;

    return (
      <div>
        <div className="form-group">
          <label>現在の選択肢</label>
          <input
            type="text"
            className="form-control"
            value={body}
            onChange={e => this.setState({ body: e.target.value })}
          />
        </div>
        <div className="form-group">
          <label><i className="material-icons" title="質問">chat_bubble_outline</i> 回答</label>
          <TextArea
            className="form-control"
            value={answer}
            onChange={e => this.setState({ answer: e.target.value })}
            rows={3}
          />
        </div>

        <div className="form-group clearfix">
          <div className="pull-right">
            <a className="btn btn-success"
              id="save-answer-button"
              href="#"
              onClick={this.onSubmit}
            >保存</a>

            &nbsp;&nbsp;
            <a className="btn btn-danger"
              id="delete-answer-button"
              href="#"
              onClick={this.onDelete}
            >削除</a>
          </div>
        </div>
      </div>
    );
  }
}

DecisionBranchForm.propTypes = {
  activeItem: activeItemType.isRequired,
  questionsTree: questionsTreeType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
  onUpdate: PropTypes.func.isRequired,
};

export default DecisionBranchForm;
