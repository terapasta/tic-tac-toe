const testHelper = require("../../test-helper");
const modulePath = testHelper.appPath("es2015/components/conversation-tree/helpers");
jest.unmock(modulePath);

const {
  findAnswerFromTree,
  findDecisionBranchFromTree,
  deleteAnswerFromTree,
  deleteDecisionBranchFromTree,
} = require(modulePath);

const sampleTree = [
  {
    id: 1,
    answer: {
      id: 1,
      decisionBranches: [
        {
          id: 1,
          answer: {
            id: 2,
            decisionBranches: []
          }
        },
        {
          id: 2,
          answer: {
            id: 3,
            decisionBranches: []
          }
        }
      ]
    }
  },
  {
    id: 1,
    answer: {
      id: 4,
      decisionBranches: []
    }
  },
];

describe("findAnswerFromTree", () => {
  it("find target answer node", () => {
    findAnswerFromTree(sampleTree, 4, (answerNode) => {
      expect(answerNode).not.toBeNull();
      expect(answerNode.id).toBe(4);
      answerNode.test = 1;
    });
    expect(sampleTree[1].answer.test).toBe(1);
  });
});

describe("findDecisionBranchFromTree", () => {
  it("find target decision branch node", () => {
    findDecisionBranchFromTree(sampleTree, 2, (decisionBranchNode) => {
      expect(decisionBranchNode).not.toBeNull();
      expect(decisionBranchNode.id).toBe(2);
      decisionBranchNode.test = 1;
    });
    expect(sampleTree[0].answer.decisionBranches[1].test).toBe(1);
  });
});

describe("deleteAnswerFromTree", () => {
  it("delete target answer node", () => {
    expect(sampleTree[0].answer.decisionBranches[0].answer).not.toBeUndefined();
    deleteAnswerFromTree(sampleTree, 2);
    expect(sampleTree[0].answer.decisionBranches[0].answer).toBeUndefined();
  });
});

describe("deleteDecisionBranchFromTree", () => {
  it("delete target decision branch node", () => {
    expect(sampleTree[0].answer.decisionBranches[1]).not.toBeUndefined();
    deleteDecisionBranchFromTree(sampleTree, 2);
    expect(sampleTree[0].answer.decisionBranches[1]).toBeUndefined();
  });
});
