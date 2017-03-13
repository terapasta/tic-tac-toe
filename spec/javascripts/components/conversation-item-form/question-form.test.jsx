import React from "react";
import { shallow } from "enzyme";
import TextArea from "react-textarea-autosize";

const testHelper = require("../../test-helper");
const componentPath = testHelper.appPath("es2015/components/conversation-item-form/question-form");
const modelPath = testHelper.appPath("es2015/models/question");
jest.unmock(componentPath);
jest.unmock(modelPath);
const QuestionForm = require(componentPath).default;
const Question = require(modelPath).default;

const editingQuestionModel = new Question({ question: "sample" });
const onChangeQuestion = jest.fn();
const onChangeAnswerBody = jest.fn();
const onClickSaveQuestionButton = jest.fn();
const onClickDeleteQuestionButton = jest.fn();

describe("QuestionForm", () => {
  describe("when editingQuestionModel does not exists", () => {
    it("return null", () => {
      const wrapper = shallow(<QuestionForm {...{
        editingQuestionModel: null,
        isProcessing: false,
        onChangeQuestion,
        onChangeAnswerBody,
        onClickSaveQuestionButton,
        onClickDeleteQuestionButton,
      }} />);
      expect(wrapper.node).toBeNull();
    });
  });

  describe("when editingDecisionBranchModel does exists", () => {
    it("renders question form", () => {
      const wrapper = shallow(<QuestionForm {...{
        editingQuestionModel,
        isProcessing: false,
        answerBody: "sample answerBody",
        question: "sample question",
        onChangeQuestion,
        onChangeAnswerBody,
        onClickSaveQuestionButton,
        onClickDeleteQuestionButton,
      }} />);

      expect(wrapper.contains(<TextArea
        className="form-control"
        name="question-question"
        rows={3}
        value="sample question"
        onChange={onChangeQuestion}
        disabled={false}
      />)).toBe(true);

      wrapper.find('[name="question-question"]').simulate('change');
      expect(onChangeQuestion).toBeCalled();

      wrapper.find('[name="answer-body"]').simulate('change');
      expect(onChangeAnswerBody).toBeCalled();

      wrapper.find('#save-question').simulate("click");
      expect(onClickSaveQuestionButton).toBeCalled();

      wrapper.find('#delete-question').simulate("click");
      expect(onClickDeleteQuestionButton).toBeCalled();
    });
  });
});
