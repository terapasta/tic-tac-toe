import React from "react";
import { shallow } from "enzyme";

const testHelper = require("../../test-helper");
const componentPath = testHelper.appPath("es2015/components/conversation-item-form/decision-branches");
const componentPath2 = testHelper.appPath("es2015/components/conversation-item-form/decision-branch-item");
const componentPath3 = testHelper.appPath("es2015/components/conversation-item-form/editing-decision-branch-item");
const modelPath = testHelper.appPath("es2015/models/decision-branch");
jest.unmock(componentPath);
jest.unmock(componentPath2);
jest.unmock(componentPath3);
jest.unmock(modelPath);
const DecisionBranches = require(componentPath).default;
const DecisionBranchItem = require(componentPath2).default;
const EditingDecisionBranchItem = require(componentPath3).default;
const DecisionBranch = require(modelPath).default;

const onSave = () => {};
const onEdit = () => {};
const onDelete = () => {};

describe("DecisionBranches", () => {
  describe("when included active item", () => {
    it("renders EditingDecisionBranchItem", () => {
      const decisionBranchModels = [
        new DecisionBranch,
        new DecisionBranch,
      ];
      decisionBranchModels[0].isActive = true;
      DecisionBranches.prototype.bindOnEdit = () => { return onEdit; };

      const wrapper = shallow(<DecisionBranches {...{
        isProcessing: false,
        decisionBranchModels,
        onSave,
        onEdit,
        onDelete,
      }} />);

      expect(wrapper.contains(<EditingDecisionBranchItem {...{
        decisionBranchModel: decisionBranchModels[0],
        key: 0,
        index: 0,
        onSave,
        onDelete,
        isDisabled: false
      }} />)).toBe(true);

      expect(wrapper.contains(<DecisionBranchItem {...{
        decisionBranchModel: decisionBranchModels[1],
        key: 0,
        onEdit,
      }} />)).toBe(true);
    });
  });

  describe("when not included active item", () => {
    it("renders DecisionBranchItem only", () => {
      const decisionBranchModels = [
        new DecisionBranch,
      ];
      DecisionBranches.prototype.bindOnEdit = () => { return onEdit; };

      const wrapper = shallow(<DecisionBranches {...{
        isProcessing: false,
        decisionBranchModels,
        onSave,
        onEdit,
        onDelete,
      }} />);

      expect(wrapper.contains(<EditingDecisionBranchItem {...{
        decisionBranchModel: decisionBranchModels[0],
        key: 0,
        index: 0,
        onSave,
        onDelete,
        isDisabled: false
      }} />)).toBe(false);

      expect(wrapper.contains(<DecisionBranchItem {...{
        decisionBranchModel: decisionBranchModels[0],
        key: 0,
        onEdit,
      }} />)).toBe(true);
    });
  });
});
