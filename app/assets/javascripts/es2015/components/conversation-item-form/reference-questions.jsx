import React, { Component, PropTypes } from "react";
import isEmpty from "is-empty";

import Question from "../../models/question";

function ReferenceQuestions(props) {
  const { referenceQuestionModels } = props;
  if (isEmpty(referenceQuestionModels)) { return null; }

  return (
    <div>
      <strong><i className="material-icons valign-middle">comment</i>{" "}対応する質問</strong>
      <ul>
        {referenceQuestionModels.map((q, i) => {
          return <li key={i}>{q.question}</li>;
        })}
      </ul>
    </div>
  );
}

ReferenceQuestions.propTypes = {
  referenceQuestionModels: PropTypes.arrayOf(PropTypes.instanceOf(Question)),
};

export default ReferenceQuestions;
