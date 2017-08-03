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

const getBodyAndAnswer = (props, { exists, empty }) => {
  const { activeItem, decisionBranchesRepo } = props;
  const decisionBranch = decisionBranchesRepo[activeItem.node.id];
  if (decisionBranch == null) { return empty(); }
  const { body, answer } = decisionBranch;
  exists(body, answer || '');
};

const findParentQuestion = (questionsTree, dbId) => (
  find(questionsTree, node => (
    includes(map(node.decisionBranches, 'id'), dbId))
  )
);

class DecisionBranchForm extends Component {
  constructor(props) {
    super(props);
    this.onSubmit = this.onSubmit.bind(this);
    this.onDelete = this.onDelete.bind(this);
    getBodyAndAnswer(props, {
      exists: (body, answer) => this.state = { body, answer, disabled: false },
      empty: () => this.state = { body: '', answer: '', disabled: false },
    });
  }

  componentWillReceiveProps(nextProps) {
    getBodyAndAnswer(nextProps, {
      exists: (body, answer) => this.setState({ body, answer }),
      empty: () => this.setState({ body: '', answer: '', disabled: false }),
    });
  }

  onSubmit() {
    if (this.state.disabled) { return; }
    this.setState({ disabled: true });

    const { body, answer } = this.state;
    const {
      activeItem,
      questionsTree,
      onUpdate,
      onNestedUpdate,
      decisionBranchesRepo,
    } = this.props;
    const { id } = activeItem.node;
    const question = findParentQuestion(questionsTree, id);
    const decisionBranch = decisionBranchesRepo[id];
    const doneHandler = () => this.setState({ disabled: false });

    if (isEmpty(decisionBranch.parentDecisionBranchId)) {
      onUpdate(question.id, id, body, answer).then(doneHandler);
    } else {
      onNestedUpdate(id, body, answer).then(doneHandler);
    }
  }

  onDelete() {
    if (this.state.disabled) { return; }
    this.setState({ disabled: true });
    if (!window.confirm('本当に削除してよろしいですか？')) { return; }

    const {
      activeItem,
      questionsTree,
      onDelete,
      onNestedDelete,
      decisionBranchesRepo,
    } = this.props;
    const { id } = activeItem.node;
    const question = findParentQuestion(questionsTree, id);
    const { parentDecisionBranchId } = decisionBranchesRepo[id];

    if (isEmpty(parentDecisionBranchId)) {
      return onDelete(question.id, id);
    } else {
      return onNestedDelete(parentDecisionBranchId, id);
    }
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
            <a className="btn btn-link"
              id="delete-answer-button"
              href="#"
              onClick={this.onDelete}
            ><span className="text-danger">削除</span></a>
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
  onDelete: PropTypes.func.isRequired,
  onNestedUpdate: PropTypes.func.isRequired,
  onNestedDelete: PropTypes.func.isRequired,
};

export default DecisionBranchForm;