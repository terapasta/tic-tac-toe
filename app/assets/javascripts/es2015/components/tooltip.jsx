import React, { Component } from "react";

export default class Tooltip extends Component {
  componentDidMount() {
    // HACK: jquery依存をやめたい
    $(this.tooltip).popover();
  }
  render() {
    const { content, placement } = this.props;

    return (
      <a href="#"
        ref={(input) => { this.tooltip = input; }}
        data-toggle="popover"
        data-placement={placement}
        data-container="body"
        data-trigger="hover"
        data-content={content}>
        <i className="material-icons">help</i>
      </a>
    );
  }
}
