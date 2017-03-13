import React from "react";
import { shallow } from "enzyme";

const testHelper = require("../test-helper");
const componentPath = testHelper.appPath("es2015/components/panel");
jest.unmock(componentPath);

const Panel = require(componentPath).default;
const { PanelHead } = require(componentPath);

describe("PanelHead", () => {
  describe("when has title", () => {
    it("renders heading", () => {
      const wrapper = shallow(<PanelHead title="sample" />);
      expect(wrapper.node).not.toBeNull();
      expect(wrapper.find(".panel-heading").length).toBe(1);
    });
  });

  describe("when has not title", () => {
    it("not renders heading", () => {
      const wrapper = shallow(<PanelHead title="" />);
      expect(wrapper.node).toBeNull();
      expect(wrapper.find("PanelHead").length).toBe(0);
    });
  });
});

describe("Panel", () => {
  describe("when modifier is null or 'default'", () => {
    it("renders .panel-default", () => {
      let wrapper;
      wrapper = shallow(<Panel modifier={null} />);
      expect(wrapper.find(".panel-default").length).toBe(1);
      wrapper = shallow(<Panel modifier="default" />);
      expect(wrapper.find(".panel-default").length).toBe(1);
    });
  });

  describe("when modifier is 'danger'", () => {
    it("renders .panel-danger", () => {
      const wrapper = shallow(<Panel modifier="danger" />);
      expect(wrapper.find(".panel-danger").length).toBe(1);
    });
  });
});
