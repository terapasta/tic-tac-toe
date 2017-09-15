import React, { Component, PropTypes } from 'react';
import bindAll from 'lodash/bindAll';

import { Input, EnterToSaveText } from './elements';

class EditingWord extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: props.defaultValue,
    };
    bindAll(this, [
      'handleMountedInput',
      'handleSubmitForm',
      'handleClickClose',
      'handleClickDelete',
    ]);
  }

  handleMountedInput(node) {
    if (node == null) { return; }
    node.select();
  }

  handleSubmitForm(e) {
    e.preventDefault();
    this.props.onSubmit(this.state.value);
  }

  handleClickClose(e) {
    e.preventDefault();
    this.props.onClose();
  }

  handleClickDelete(e) {
    e.preventDefault();
    this.props.onDelete();
  }

  render() {
    const {
      onClose,
      onDelete,
    } = this.props;

    const {
      value,
    } = this.state;

    return (
      <span>
        <form onSubmit={this.handleSubmitForm}>
          <Input
            value={value}
            onChange={(e) => this.setState({ value: e.target.value })}
            innerRef={this.handleMountedInput}
          />
          <EnterToSaveText />
        </form>
        &nbsp;
        {onClose != null && (
          <button href="#" onClick={this.handleClickClose}>
            <i className="material-icons">close</i>
          </button>
        )}
        {onDelete != null && (
          <button href="#" onClick={this.handleClickDelete} className="delete-button">
            <span className="text-danger">削除</span>
          </button>
        )}
      </span>
    );
  }
}

EditingWord.propTypes = {
  defaultValue: PropTypes.string,
  onClose: PropTypes.func,
  onSubmit: PropTypes.func.isRequired,
  onDelete: PropTypes.func,
};

EditingWord.defaultProps = {
  defaultValue: '',
  onClose: null,
  onDelete: null,
};

export default EditingWord;
