import React from "react";
import { shallow } from "enzyme";

const testHelper = require("../../test-helper");
const componentPath = testHelper.appPath("es2015/components/conversation-item-form/current-decision-branch");
const modelPath = testHelper.appPath("es2015/models/decision-branch");
jest.unmock(componentPath);
jest.unmock(modelPath);
const CurrentDecisionBranch = require(componentPath).default;
const DecisionBranch = require(modelPath).default;

describe("CurrentDecisionBranch", () => {
  describe("when activeItem.dataType is answer", () => {
    it("not renders", () => {
      const activeItem = { dataType: "answer" };
      const wrapper = shallow(<CurrentDecisionBranch {...{ activeItem }} />);
      expect(wrapper.node).toBeNull();
    });
  });

  describe("when activeItem.dataType is decisionBranch", () => {
    describe("when editingDecisionBranchModel does not exists", () => {
      it("not renders", () => {
        const activeItem = { dataType: "decisionBranch" };
        const wrapper = shallow(<CurrentDecisionBranch {...{ activeItem, CurrentDecisionBranch: null }} />);
        expect(wrapper.node).toBeNull();
      });
    });

    describe("when editingDecisionBranchModel does exists", () => {
      it("renders decision branch", () => {
        const activeItem = { dataType: "decisionBranch" };
        const editingDecisionBranchModel = new DecisionBranch({ body: "hoge" });
        const wrapper = shallow(<CurrentDecisionBranch {...{
          activeItem,
          editingDecisionBranchModel
        }} />);
        const input = <input
          className="form-control"
          disabled={true}
          type="text"
          value="hoge"
        />;
        expect(wrapper.contains(input)).toBe(true);
      });
    });
  });

  describe("when activeItem.dataType is question", () => {
    it("not renders", () => {
      const activeItem = { dataType: "question" };
      const wrapper = shallow(<CurrentDecisionBranch {...{ activeItem }} />);
      expect(wrapper.node).toBeNull();
    });
  });
});
