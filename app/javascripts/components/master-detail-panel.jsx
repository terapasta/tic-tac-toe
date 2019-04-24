import React, { Component } from "react";

export default class MasterDetailPanel extends Component {
  render() {
    const { title, children } = this.props;
    return (
      <div className="master-detail-panel">
        <div className="master-detail-panel__body">
          {children}
        </div>
      </div>
    );
  }
}

export class Master extends Component {
  render() {
    const { children } = this.props;
    return (
      <div className="master-detail-panel__master">
        {children}
      </div>
    );
  }
}

export class Detail extends Component {
  render() {
    const { children } = this.props;
    return (
      <div className="master-detail-panel__detail">
        {children}
      </div>
    );
  }
}
