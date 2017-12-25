import React, { Component } from 'react'
import PropTypes from 'prop-types'
import nl2br from 'react-nl2br'

import Modal from './Modal'

class Alert extends Component {
  render() {
    const {
      title,
      subtitle,
      onCancel,
      onOK,
    } = this.props;

    return (
      <Modal narrow title={title}>
        <p>{nl2br(subtitle)}</p>
        <div className="text-right">
          {onCancel != null && (
            <button
              className="btn btn-default btn-secondary"
              onClick={onCancel}
            >キャンセル</button>
          )}
          &nbsp;
          {onOK != null && (
            <button
              className="btn btn-primary"
              onClick={onOK}
            >OK</button>
          )}
        </div>
      </Modal>
    );
  }
}

Alert.propTypes = {
  title: PropTypes.string.isRequired,
  subtitle: PropTypes.string.isRequired,
  onCancel: PropTypes.func,
  onOK: PropTypes.func,
};

Alert.defaultProps = {
  onCancel: null,
  onOK: null,
};

export default Alert;
