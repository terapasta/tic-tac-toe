import React, { Component, PropTypes } from 'react';

class EditingDecisionBranchForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      body: props.decisionBranch.body,
    };
  }

  render() {
    const { onSave, onDelete, decisionBranch } = this.props;
    const { body } = this.state;

    return (
      <li
        id={`decision-branch-item-${decisionBranch.id}`}
        className="list-group-item clearfix"
      >
        <div className="input-group">
          <input className="form-control" type="text"
            value={body}
            name="decision-branch-body"
            onChange={e => this.setState({ body: e.target.value })}
          />
          <span className="input-group-btn">
            <button
              className="btn btn-success"
              onClick={() => onSave(body)}
            >保存</button>
            {" "}
            <button
              className="btn btn-default"
              onClick={onDelete}
            ><span className="text-danger">削除</span></button>
          </span>
        </div>
      </li>
    );
  }
}

EditingDecisionBranchForm.propTypes = {
  decisionBranch: PropTypes.shape({
    body: PropTypes.string,
  }).isRequired,
  onSave: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
};

export default EditingDecisionBranchForm;
