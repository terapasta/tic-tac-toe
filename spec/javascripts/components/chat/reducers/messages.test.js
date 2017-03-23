import Promise from "promise";
import testHelper from "../../../test-helper";

const namespace = "es2015/components/chat";
const reducerPath = testHelper.appPath(`${namespace}/reducers/messages`);
const actionCreatorPath = testHelper.appPath(`${namespace}/action-creators`);

jest.unmock(reducerPath);
jest.unmock(actionCreatorPath);

const messages = require(reducerPath).default;
const { fetchMessages } = require(actionCreatorPath);

describe("chat/reducers/messages", () => {
  describe("fetchMessages", () => {
    describe("when succeeded", () => {
      it("returns merged state", () => {
        const fakeResponse = { data: { messages: [2, 3], total_pages: 10 } };
        const fakeAction = {
          error: false,
          type: "FETCH_MESSAGES",
          payload: fakeResponse,
        };
        const state = messages({ data: [1] }, fakeAction);
        expect(state).toEqual({
          data: [1, 2, 3],
          totalPages: 10
        });
      });
    });

    describe("when failed", () => {
      it("returns old state", () => {
        const fakeAction = {
          error: true,
          type: "FETCH_MESSAGES",
          payload: "fakeResponse",
        };
        const state = messages("old", fakeAction);
        expect(state).toEqual("old");
      });
    });
  });
});
