import React, { Component } from "react";
import isEmpty from "is-empty";

export default class Modal extends Component {
  render() {
    const { onClose, title, children, iframeUrl, wide } = this.props;

    return (
      <span>
        <div className="modal-backdrop fade show" />
        <div className="modal fade show"
             style={{display:"block", overflowY:"auto"}}
             onClick={() => { onClose(); }}>
          <div className={"modal-dialog" + (wide ? " wide" : "")}
            onClick={(e) => { e.stopPropagation(); }}>
            <div className="modal-content">
              <div className="modal-header">
                <h4 className="modal-title">{title}</h4>
                <button className="close" onClick={() => { onClose(); }}>&times;</button>
              </div>
              {isEmpty(iframeUrl) && (
                <div className="modal-body">
                  {children}
                </div>
              )}
              {!isEmpty(iframeUrl) && (
                <iframe className="modal-iframe" src={iframeUrl} />
              )}
            </div>
          </div>
        </div>
      </span>
    );
  }
}
