import React, { Component } from 'react'
import PropTypes from 'prop-types'
import bindAll from 'lodash/bindAll'
import get from 'lodash/get'

import setCaretPosition from '../../helpers/setCaretPosition'

import {
  Word,
  Input,
  EnterToSaveText,
} from './elements'

const setCaretToTail = (input) => {
  if (input == null) { return; }
  setCaretPosition(input, get(input, 'value', '').length)
}

class EditingSynonym extends Component {
  constructor(props) {
    super(props)
    this.state = {
      value: props.synonym.value,
    }
    bindAll(this, [
      'handleSubmit',
    ])
  }

  componentDidMount() {
    if (this.input == null) { return; }
    this.input.select();
  }

  handleSubmit(e) {
    e.preventDefault();
    const { synonym, onSave } = this.props;
    onSave(synonym.id, this.state.value);
  }

  render() {
    const {
      synonym,
      onDelete,
      onClose,
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
        <button onClick={() => onClose()}>
          <i className="material-icons">close</i>
        </button>
        <button onClick={() => onDelete(synonym.id)} className="delete-button">
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
