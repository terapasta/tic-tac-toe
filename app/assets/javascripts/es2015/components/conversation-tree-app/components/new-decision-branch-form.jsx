import React, { Component, PropTypes } from 'react';

class NewDecisionBranchForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      body: '',
      isAdding: false,
    };

    this.onClickSave = this.onClickSave.bind(this);
  }

  onClickSave() {
    this.props.onSave(this.state.body).then(() => {
      this.setState({
        body: '',
        isAdding: false,
      });
    });
  }

  renderForm() {
    const { body } = this.state;

    return (
      <div>
        <div className="input-group">
          <input
            className="form-control"
            placeholder="新しい選択肢を入力"
            value={body}
            onChange={e => this.setState({ body: e.target.value })}
            disabled={false}
            name="decision-branch-body"
          />
          <span className="input-group-btn">
            <span
              className="btn btn-success"
              disabled={false}
              onClick={this.onClickSave}>
              追加
            </span>
          </span>
        </div>
        <div className="padding-top-8 d-flex justify-content-between">
          <span
            className="btn btn-link"
            onClick={() => this.setState({ isAdding: false })}
            disabled={false}
          >
            キャンセル
          </span>
        </div>
      </div>
    );
  }

  renderButton() {
    return (
      <div className="nav nav-pills nav-stacked">
        <li className="hover-gray">
          <span
            className="btn btn-link"
            onClick={() => this.setState({ isAdding: true })}
            id="add-decision-branch-button"
          >
            ＋選択肢を追加する
          </span>
        </li>
      </div>
    );
  }

  render() {
    const { isAdding } = this.state;

    if (isAdding) {
      return this.renderForm();
    } else {
      return this.renderButton();
    }
  }
}

NewDecisionBranchForm.propTypes = {
  onSave: PropTypes.func.isRequired,
};

export default NewDecisionBranchForm;
