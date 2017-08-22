import React, { Component } from "react";
import classnames from 'classnames';
import isEmpty from "is-empty";

export default class Modal extends Component {
  render() {
    const { onClose, title, children, iframeUrl, wide, narrow } = this.props;

    const dialogStyle = {
      width: narrow ? '300px' : '',
    };

    return (
      <span>
        <div className="modal-backdrop fade in" />
        <div className="modal fade in"
             style={{display:"block", overflowY:"auto"}}
             onClick={() => { onClose(); }}>
          <div
            className={classnames('modal-dialog', { wide })}
            onClick={(e) => e.stopPropagation()}
            style={dialogStyle}
          >
            <div className="modal-content">
              <div className="modal-header">
                <button className="close" onClick={() => { onClose(); }}>&times;</button>
                <h4 className="modal-title">{title}</h4>
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
