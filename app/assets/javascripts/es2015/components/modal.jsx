import React from "react";
import isEmpty from "is-empty";

export default function Modal(props) {
  const { onClose, title, children, iframeUrl, wide } = props;

  return (
    <span>
      <div className="modal-backdrop fade in" />
      <div className="modal fade in"
           style={{display:"block", overflowY:"auto"}}
           onClick={() => { onClose(); }}>
        <div className={"modal-dialog" + (wide ? " wide" : "")}
          onClick={(e) => { e.stopPropagation(); }}>
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
              <iframe className="modal-iframe" src={iframeUrl} />
            )}
          </div>
        </div>
      </div>
    </span>
  );
}
