import React from "react";
import { mount, shallow } from "enzyme";
import axios from "axios";
import Promise from "promise";
import testHelper from "../test-helper";

const componentPath = testHelper.appPath("es2015/components/question-answer-form");
const panelComponentPath = testHelper.appPath("es2015/components/panel");
const modelPath = testHelper.appPath("es2015/models/question");

jest.unmock(componentPath);
jest.unmock(panelComponentPath);
jest.unmock(modelPath);

const QuestionAnswerForm = require(componentPath).default;
const { AnswerMode } = require(componentPath);
const Question = require(modelPath).default;

let fakeFetch;
let originalFetch = Question.fetch;
let originalAxiosGet = axios.get;

describe("QuestionAnswerForm", () => {
  beforeEach(() => {
    Question.fetch = fakeFetch = jest.fn(() => {
      return { then: ()=>{} };
    });
  });

  afterEach(() => {
    Question.fetch = originalFetch;
  })

  describe("when exists id prop", () => {
    it("requests to question_answers#show.json", () => {
      const wrapper = mount(<QuestionAnswerForm {...{
        botId: 1,
        id: 1,
      }} />);
      expect(Question.fetch).toBeCalledWith(1, 1);
    });
  });

  describe("when not exists id prop", () => {
    it("never requests to question_answers#show.json", () => {
      const wrapper = mount(<QuestionAnswerForm {...{
        botId: 1,
        id: null,
      }} />);
      expect(Question.fetch).not.toBeCalled();
    });
  });

  describe("when input text to question body's textarea", () => {
    it("calls onChangeQuestionBody and set value to questionBody state", () => {
      const wrapper = shallow(<QuestionAnswerForm {...{
        botId: 1,
        id: 1,
      }} />);

      expect(wrapper.state("questionBody")).toBe("");

      const fakeEvent = { target: { value: "sample value" } };
      wrapper.find("#question-body").simulate("change", fakeEvent);

      expect(wrapper.state("questionBody")).toBe("sample value");
    });
  });

  describe("when change answer mode", () => {
    it("assigns new answerMode state", () => {
      const wrapper = shallow(<QuestionAnswerForm {...{
        botId: 1,
        id: 1
      }} />);

      expect(wrapper.state("answerMode")).toBe("input");

      wrapper.find("#answer-mode").simulate("change", "select");

      expect(wrapper.state("answerMode")).toBe("select");
    });
  });

  describe("when answerMode is input", () => {
    describe("when input text to answer body's textarea", () => {
      it("assigns new answerBody state", () => {
        const wrapper = shallow(<QuestionAnswerForm {...{
          botId: 1,
          id: 1,
        }} />)

        const fakeEvent = { target: { value: "sample answer body" } };
        wrapper.find("#answer-body").simulate("change", fakeEvent);

        expect(wrapper.state("answerBody")).toBe("sample answer body");
      });
    });
  });

  describe("when answerMode is select", () => {
    describe("when input text to searching answer field", () => {
      it("searches answers", () => {
        const wrapper = shallow(<QuestionAnswerForm {...{
          botId: 1,
          id: 1,
        }} />)

        const instance = wrapper.instance()
        instance.debouncedSearchAnswers = jest.fn();

        wrapper.setState({
          answerMode: AnswerMode.Select,
          candidateAnswers: ["sample answer"]
        });

        const fakeEvent = { target: { value: "sample query" } };
        wrapper.find("#answer-search").simulate("change", fakeEvent);

        expect(instance.debouncedSearchAnswers).toBeCalled();

        instance.debouncedSearchAnswers = jest.fn();

        const fakeEvent2 = { target: { value: "" } };
        wrapper.find("#answer-search").simulate("change", fakeEvent2);

        expect(instance.debouncedSearchAnswers).not.toBeCalled();
        expect(wrapper.state("candidateAnswers")).toEqual([]);
      });
    });
  });

  describe("#searchAnswers", () => {
    beforeEach(() => {
      axios.get = jest.fn(() => {
        return new Promise((resolve) => {
          resolve({ data: ["sample answer"] });
        });
      });
    });

    afterEach(() => {
      axios.get = originalAxiosGet;
    });

    describe("when isProcessing is false", () => {
      it("does request to search API and set true to isProcessing", () => {
        const wrapper = shallow(<QuestionAnswerForm {...{
          botId: 1,
          id: 1,
        }} />)

        wrapper.setState({ isProcessing: false, searchingAnswerQuery: "sample" });
        expect(wrapper.state("candidateAnswers")).toEqual([]);

        return wrapper.instance().searchAnswers().then(() => {
          expect(axios.get).toBeCalledWith("/bots/1/answers.json", {
            params: {
              "q[body_or_headline_cont]": "sample",
              page: 1,
            }
          });
          expect(wrapper.state("candidateAnswers")).toEqual(["sample answer"]);
        });
      });
    });

    describe("when isProcessing is true", () => {
      it("does not request to search API", () => {
        const wrapper = shallow(<QuestionAnswerForm {...{
          botId: 1,
          id: 1,
        }} />);

        wrapper.setState({ isProcessing: true, searchingAnswerQuery: "sample" });
        expect(wrapper.instance().searchAnswers()).toBeUndefined();
        expect(axios.get).not.toBeCalled();
      });
    });
  });

  describe("each candidate answers", () => {
    describe("when click one of candidate answers", () => {
      it("does assign to selectedAnswer that is clicked one", () => {
        const wrapper = shallow(<QuestionAnswerForm {...{
          botId: 1,
          id: 1,
        }} />);
        const candidateAnswers = [
          { id: 1, body: "target answer" },
        ];
        const instance = wrapper.instance();
        const fakeEvent = { preventDefault: () => {} };

        const originalHandler = instance.onClickCandidateAnswer;
        instance.onClickCandidateAnswer = jest.fn((answer, e) => {
          originalHandler.call(instance, answer, e);
        });

        wrapper.setState({ answerMode: AnswerMode.Select, candidateAnswers });
        wrapper.find("#candidate-answers").find("Panel")
          .node.props.onClickBody(fakeEvent);

        expect(instance.onClickCandidateAnswer).toBeCalledWith(
          candidateAnswers[0], fakeEvent
        );
        expect(wrapper.state("selectedAnswer")).toEqual(candidateAnswers[0]);
        expect(wrapper.state("searchingAnswerQuery")).toBe("");
      });
    });
  });

  describe("selected answer", () => {
    describe("when click reject button", () => {
      it("clear selectedAnswer", () => {
        const wrapper = shallow(<QuestionAnswerForm {...{
          botId: 1,
          id: 1,
        }} />);
        const selectedAnswer = { id: 123 };
        const fakeEvent = { preventDefault(){} };
        wrapper.setState({ answerMode: AnswerMode.Select, selectedAnswer });
        wrapper.find("#reject-answer").simulate("click", fakeEvent);
        expect(wrapper.state("selectedAnswer")).toBeNull();
      });
    });
  });

  describe("when input text to answer headline's input", () => {
    it("calls onChangeAnswerHeadline and assign value to answerHeadline", () => {
      const wrapper = shallow(<QuestionAnswerForm {...{
        botId: 1,
        id: 1,
      }} />);
      const fakeEvent = { target: { value: "sample headline" } };
      const instance = wrapper.instance();

      wrapper.find("#answer-headline").simulate("change", fakeEvent);
      expect(wrapper.state("answerHeadline")).toBe("sample headline");
    });
  });

  describe("when click submit button", () => {
    describe("when answerMode is 'input'", () => {
      describe("when empty answerBody", () => {
        it("does not send POST request", () => {
          const wrapper = shallow(<QuestionAnswerForm {...{
            botId: 1,
            id: 1,
          }} />);
          const instance = wrapper.instance();
          instance.saveQuestionAnswer = jest.fn();
          window.alert = jest.fn();
          wrapper.setState({
            questionBody: "sample",
            answerMode: AnswerMode.Input,
            answerBody: "",
          });
          wrapper.find("input[type='submit']").simulate("click");
          expect(instance.saveQuestionAnswer).not.toBeCalled();
          expect(window.alert).toBeCalled();
        });
      });

      describe("when filled answerBody", () => {
        it("does send POST request", () => {
          const wrapper = shallow(<QuestionAnswerForm {...{
            botId: 1,
            id: 1,
          }} />);
          const instance = wrapper.instance();
          instance.saveQuestionAnswer = jest.fn();
          window.alert = jest.fn();
          wrapper.setState({
            questionBody: "sample",
            answerMode: AnswerMode.Input,
            answerBody: "sample",
          });
          wrapper.find("input[type='submit']").simulate("click");
          expect(instance.saveQuestionAnswer).toBeCalledWith({
            question: "sample",
            answer_attributes: {
              body: "sample",
              headline: "",
            },
          });
          expect(window.alert).not.toBeCalled();
        });
      })
    });

    describe("when answerMode is 'select'", () => {
      describe("when selected answer", () => {
        it("does send POST request", () => {
          const wrapper = shallow(<QuestionAnswerForm {...{
            botId: 1,
            id: 1,
          }} />);
          const instance = wrapper.instance();
          instance.saveQuestionAnswer = jest.fn();
          window.alert = jest.fn();
          wrapper.setState({
            questionBody: "sample",
            answerMode: AnswerMode.Select,
            selectedAnswer: { id: 1 },
          });
          wrapper.find("input[type='submit']").simulate("click");
          expect(instance.saveQuestionAnswer).toBeCalledWith({
            question: "sample",
            answer_id: 1,
          });
          expect(window.alert).not.toBeCalled();
        });
      });

      describe("when not yet selected answer", () => {
        it("does not send POST request", () => {
          const wrapper = shallow(<QuestionAnswerForm {...{
            botId: 1,
            id: 1,
          }} />);
          const instance = wrapper.instance();
          instance.saveQuestionAnswer = jest.fn();
          window.alert = jest.fn();
          wrapper.setState({
            questionBody: "sample",
            answerMode: AnswerMode.Select,
            selectedAnswer: null,
          });
          wrapper.find("input[type='submit']").simulate("click");
          expect(instance.saveQuestionAnswer).not.toBeCalledWith();
          expect(window.alert).toBeCalled();
        });
      });
    });
  });

  describe("#saveQuestionAnswer", () => {
    describe("when exists id", () => {
      xit("does send request to question_answers#update", () => {
      });
    });

    describe("when not exists id", () => {
      xit("does send request to question_answers#create", () => {
      });
    });
  });
});
