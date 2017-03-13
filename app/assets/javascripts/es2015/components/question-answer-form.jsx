import React, { Component, PropTypes } from "react";

import Panel from "./panel";

export default class QuestionAnswerForm extends Component {
  static get componentName() {
    return "QuestionAnswerForm";
  }

  static get propTypes() {
    return {
    };
  }

  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <Panel title="Q&A">
        <form>
          <div className="form-group">
            <input className="btn btn-primary" value="登録" />
          </div>
        </form>
      </Panel>
    );
  }
}
