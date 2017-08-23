import React, { Component, PropTypes } from 'react';
import bindAll from 'lodash/bindAll';
import get from 'lodash/get';

import setCaretPosition from '../../modules/set-caret-position';

import {
  Word,
  Input,
  EnterToSaveText,
} from './elements';

const setCaretToTail = (input) => {
  if (input == null) { return; }
  setCaretPosition(input, get(input, 'value', '').length);
};

class EditingSynonym extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: props.synonym.value,
    };
    bindAll(this, [
      'handleSubmit',
      'handleClickClose',
      'handleClickDelete',
    ]);
  }

  componentDidMount() {
    this.input.select();
  }

  handleSubmit() {
    const { synonym, onSave } = this.props;
    onSave(synonym.id, this.state.value);
  }

  handleClickClose() {
    this.props.onClose();
  }

  handleClickDelete() {
    this.props.onDelete(this.props.synonym.id);
  }

  render() {
    const {
      synonym,
    } = this.props;

    const {
      value,
    } = this.state;

    return (
      <Word noBorder noPadding key={synonym.id}>
        <form onSubmit={this.handleSubmit}>
          <Input
            type="text"
            value={value}
            onChange={(e) => this.setState({ value: e.target.value })}
            innerRef={(node) => this.input = node}
          />
        </form>
        &nbsp;
        <button onClick={this.handleClickClose}>
          <i className="material-icons">close</i>
        </button>
        <button onClick={this.handleClickDelete} className="delete-button">
          <span className="text-danger">削除</span>
        </button>
        <EnterToSaveText />
      </Word>
    );
  }
}

EditingSynonym.propTypes = {
  synonym: PropTypes.shape({
    id: PropTypes.number,
    value: PropTypes.value,
  }).isRequired,
  onSave: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
};

export default EditingSynonym;
