import React, { PropTypes } from "react";
import isEmpty from "is-empty";
import includes from "lodash/includes";
import assign from "lodash/assign";

import BaseNode from "./base-node";
import DecisionBranchNode from "./decision-branch-node";

export default class DecisionBranchNodes extends BaseNode {
  static get componentName() {
    return "DecisionBranchNodes";
  }

  static get propTypes() {
    return assign({}, super.propTypes, {
      decisionBranchNodes: PropTypes.array.isRequired,
    });
  }

  render() {
    const {
      answerNode,
      decisionBranchNodes,
      openedAnswerIDs,
    } = this.props;

    if (isEmpty(decisionBranchNodes)) { return null; }

    const style = {
      display: includes(openedAnswerIDs, answerNode.id) ? "block" : null,
    };

    return (
      <ol className="tree" style={style}>
        {decisionBranchNodes.map((decisionBranchNode, index) => {
          return <DecisionBranchNode
            {...this.props}
            {...{ decisionBranchNode }}
            key={index}
          />
        })}
      </ol>
    );
  }
}
