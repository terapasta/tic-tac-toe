import React, { Component, PropTypes } from 'react';

import Modal from '../modal';

class ConfirmModal extends Component {
  render() {
    const { title, subtitle, onCancel, onOK } = this.props;

    return (
      <Modal narrow title={title}>
        <p>{subtitle}</p>
        <div className="text-right">
          <button
            className="btn btn-default"
            onClick={onCancel}
          >
            キャンセル
          </button>
          &nbsp;
          <button
            className="btn btn-primary"
            onClick={onOK}
          >OK</button>
        </div>
      </Modal>
    );
  }
}

ConfirmModal.propTypes = {
  title: PropTypes.string.isRequired,
  subtitle: PropTypes.string.isRequired,
  onCancel: PropTypes.func.isRequired,
  onOK: PropTypes.func.isRequired,
};

export default ConfirmModal;
