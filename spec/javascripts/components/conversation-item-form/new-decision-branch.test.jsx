import React from "react";
import { shallow } from "enzyme";

const testHelper = require("../../test-helper");
const componentPath = testHelper.appPath("es2015/components/conversation-item-form/new-decision-branch");
const modelPath = testHelper.appPath("es2015/models/answer");
jest.unmock(componentPath);
jest.unmock(modelPath);

const NewDecisionBranch = require(componentPath).default;
const Answer = require(modelPath).default;

const persistedAnswerModel = new Answer({ id: 1 });
const draftAnswerModel = new Answer({});
const questionActiveItem = { dataType: "question" };
const answerActiveItem = { dataType: "answer" };
const onSave = jest.fn();
const onAdding = jest.fn();
const onCancelAdding = jest.fn();

describe("NewDecisionBranch", () => {
  describe("when activeItem.dataType is 'answer'", () => {
    describe("when editingAnswerModel is persisted", () => {
      describe("when isAdding is true", () => {
        it("renders adding button", () => {
          const wrapper = shallow(<NewDecisionBranch {...{
            editingAnswerModel: persistedAnswerModel,
            activeItem: answerActiveItem,
            isProcessing: false,
            isAdding: false,
            onSave,
            onAdding,
            onCancelAdding,
          }} />);

          expect(wrapper.find("#add-decision-branch-button").length).toBe(1);
          expect(wrapper.find(".form-control").length).toBe(0);

          wrapper.find(".btn-link").simulate("click");
          expect(onAdding).toBeCalled();
        });
      });

      describe("when isAdding is false", () => {
        it("renders adding form", () => {
          const wrapper = shallow(<NewDecisionBranch {...{
            editingAnswerModel: persistedAnswerModel,
            activeItem: answerActiveItem,
            isProcessing: false,
            isAdding: true,
            onSave,
            onAdding,
            onCancelAdding,
          }} />);

          expect(wrapper.find("#add-decision-branch-button").length).toBe(0);
          expect(wrapper.find(".form-control").length).toBe(1);

          wrapper.find(".btn-link").simulate("click");
          expect(onCancelAdding).toBeCalled();

          wrapper.find(".btn-primary").simulate("click");
          expect(onSave).toBeCalled();
        });
      })
    });

    describe("when editingAnswerModel is not persisted", () => {
      it("returns null", () => {
        const wrapper = shallow(<NewDecisionBranch {...{
          editingAnswerModel: draftAnswerModel,
          activeItem: answerActiveItem,
          isProcessing: false,
          isAdding: true,
          onSave,
          onAdding,
          onCancelAdding,
        }} />);

        expect(wrapper.node).toBeNull();
      })
    });
  });

  describe("when activeItem.dataType is not 'answer'", () => {
    it("returns null", () => {
      const wrapper = shallow(<NewDecisionBranch {...{
        editingAnswerModel: null,
        activeItem: questionActiveItem,
        isProcessing: false,
        isAdding: true,
        onSave,
        onAdding,
        onCancelAdding,
      }} />);

      expect(wrapper.node).toBeNull();
    });
  });
});
