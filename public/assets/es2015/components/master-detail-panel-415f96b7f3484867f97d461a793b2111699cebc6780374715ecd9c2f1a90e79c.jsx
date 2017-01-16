import React from "react";

export default function MasterDetailPanel(props = {}) {
  const { title, children } = props;
  return (
    <div className="master-detail-panel">
      <div className="master-detail-panel__header">
        <h1 className="master-detail-panel__title">{title}</h1>
      </div>
      <div className="master-detail-panel__body">
        {children}
      </div>
    </div>
  );
}

export function Master(props) {
  const { children } = props;
  return (
    <div className="master-detail-panel__master">
      {children}
    </div>
  );
}

export function Detail(props) {
  const { children } = props;
  return (
    <div className="master-detail-panel__detail">
      {children}
    </div>
  );
}
