import React from "react";
import { shallow } from "enzyme";
import TextArea from "react-textarea-autosize";

const testHelper = require("../../test-helper");
const componentPath = testHelper.appPath("es2015/components/conversation-item-form/answer-form");
const modelPath = testHelper.appPath("es2015/models/answer");
jest.unmock(componentPath);
jest.unmock(modelPath);

const AnswerForm = require(componentPath).default;
const Answer = require(modelPath).default;

const editingAnswerModel = new Answer({ id: 1 });
const questionActiveItem = { dataType: "question" };
const answerActiveItem = { dataType: "answer" };
const decisionBranchActiveItem = { dataType: "decisionBranch" };
const onChange = jest.fn();
const onSave = jest.fn();
const onDelete = jest.fn();

describe("AnswerForm", () => {
  describe("when activeItem.dataType is answer", () => {
    describe("when editingAnswerModel is null", () => {
      it("returns null", () => {
        const wrapper = shallow(<AnswerForm
          {...{
            activeItem: answerActiveItem,
            editingAnswerModel: null,
            answerBody: "",
            isProcessing: false,
            onChange() {},
            onSave() {},
            onDelete() {},
          }}
        />);

        expect(wrapper.node).toBeNull();
      });
    });

    describe("when editingAnswerModel is not null", () => {
      it("renders form", () => {
        const wrapper = shallow(<AnswerForm
          {...{
            activeItem: answerActiveItem,
            editingAnswerModel,
            answerBody: "",
            isProcessing: false,
            onChange,
            onSave,
            onDelete,
          }}
        />);
        const textArea = wrapper.find("#answer-body");
        expect(textArea.length).toBe(1);

        textArea.simulate("change");
        expect(onChange).toBeCalled();

        wrapper.find("#save-answer-button").simulate("click");
        expect(onSave).toBeCalled();

        wrapper.find("#delete-answer-button").simulate("click");
        expect(onDelete).toBeCalled();
      });
    });
  });

  describe("when activeItem.dataType is decisionBranch", () => {
    describe("when editingAnswerModel is null", () => {
      it("returns null", () => {
        const wrapper = shallow(<AnswerForm
          {...{
            activeItem: decisionBranchActiveItem,
            editingAnswerModel: null,
            answerBody: "",
            isProcessing: false,
            onChange() {},
            onSave() {},
            onDelete() {},
          }}
        />);

        expect(wrapper.node).toBeNull();
      });
    });

    describe("when editingAnswerModel is not null", () => {
      it("renders form", () => {
        const wrapper = shallow(<AnswerForm
          {...{
            activeItem: decisionBranchActiveItem,
            editingAnswerModel,
            answerBody: "",
            isProcessing: false,
            onChange,
            onSave,
            onDelete,
          }}
        />);
        const textArea = wrapper.find("#answer-body");
        expect(textArea.length).toBe(1);

        textArea.simulate("change");
        expect(onChange).toBeCalled();

        wrapper.find("#save-answer-button").simulate("click");
        expect(onSave).toBeCalled();

        wrapper.find("#delete-answer-button").simulate("click");
        expect(onDelete).toBeCalled();
      });
    });
  });

  describe("when activeItem.dataType is question", () => {
    it("returns null", () => {
      const wrapper = shallow(<AnswerForm
        {...{
          activeItem: questionActiveItem,
          editingAnswerModel: null,
          answerBody: "",
          isProcessing: false,
          onChange() {},
          onSave() {},
          onDelete() {},
        }}
      />);

      expect(wrapper.node).toBeNull();
    });
  });
});
