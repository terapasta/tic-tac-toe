import React, { Component, PropTypes } from 'react';

class EditingDecisionBranchForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      body: props.decisionBranch.body,
    };
  }

  render() {
    const { onSave, onDelete } = this.props;
    const { body } = this.state;

    return (
      <li className="list-group-item clearfix">
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
              className="btn btn-danger"
              onClick={onDelete}
            >削除</button>
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
