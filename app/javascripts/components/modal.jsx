import React, { Component } from "react";
import classnames from 'classnames';
import isEmpty from "is-empty";

export default class Modal extends Component {
  constructor(props) {
    super(props);
    this.handleClose = this.handleClose.bind(this)
  }

  handleClose() {
    const { onClose } = this.props;
    if (typeof onClose === 'function')  {
      onClose();
    }
  }

  render() {
    const {
      onClose,
      title,
      children,
      iframeUrl,
      wide,
      narrow,
    } = this.props;

    const dialogStyle = {
      width: narrow ? '300px' : '',
    };

    return (
      <span>
        <div className="modal-backdrop fade show" />
        <div className="modal fade show"
             style={{display:"block", overflowY:"auto"}}
             onClick={this.handleClose}>
          <div
            className={classnames('modal-dialog', { wide })}
            onClick={(e) => e.stopPropagation()}
            style={dialogStyle}
          >
            <div className="modal-content">
              <div className="modal-header">
                <h4 className="modal-title">{title}</h4>
                {typeof onClose === 'function' && (
                  <button className="close" onClick={() => { onClose(); }}>&times;</button>
                )}
              </div>
              {isEmpty(iframeUrl) && (
                <div className="modal-body">
                  {children}
                </div>
              )}
              {!isEmpty(iframeUrl) && (
                <iframe className="modal-iframe" src={iframeUrl} title={title} />
              )}
            </div>
          </div>
        </div>
      </span>
    );
  }
}
