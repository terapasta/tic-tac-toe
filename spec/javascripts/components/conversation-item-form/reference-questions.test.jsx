import React from "react";
import { shallow } from "enzyme";

const testHelper = require("../../test-helper");
const componentPath = testHelper.appPath("es2015/components/conversation-item-form/reference-questions");
const modelPath = testHelper.appPath("es2015/models/question");
jest.unmock(componentPath);
jest.unmock(modelPath);
const ReferenceQuestions = require(componentPath).default;
const Question = require(modelPath).default;

describe("ReferenceQuestions", () => {
  describe("when referenceQuestionModels does not exists", () => {
    it("not renders", () => {
      const wrapper = shallow(<ReferenceQuestions referenceQuestionModels={[]} />);
      expect(wrapper.node).toBeNull();
    });
  });

  describe("when referenceQuestionModels does exists", () => {
    it("renders reference questions", () => {
      const models = [new Question({ question: "hoge" })];
      const wrapper = shallow(<ReferenceQuestions referenceQuestionModels={models} />);
      expect(wrapper.contains(<li key={0}>hoge</li>)).toBe(true);
    });
  });
});
