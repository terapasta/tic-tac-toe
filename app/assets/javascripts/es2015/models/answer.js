import axios from "axios";
import assign from "lodash/assign";

import DecisionBranch from "./decision-branch";
import Question from "./question";

import authenticityToken from "../modules/authenticity-token";
import snakeCaseKeys from "../modules/snake-case-keys";

export default class Answer {
  static fetch(botId, id) {
    return axios.get(`/bots/${botId}/answers/${id}.json`)
      .then((res) => {
        return new Answer(assign({ botId }, res.data));
      });
  }

  static create(botId, attrs) {
    return axios.post(`/bots/${botId}/answers.json`, {
        answer: attrs,
        authenticity_token: authenticityToken(),
      })
      .then((res) => {
        return new Answer(res.data);
      });
  }

  constructor(attrs = {}) {
    this.attrs = attrs;
  }

  get id() { return this.attrs.id; }
  get body() { return this.attrs.body; }

  fetchDecisionBranches() {
    const { id, botId } = this.attrs;
    return axios.get(`/bots/${botId}/answers/${id}/decision_branches.json`)
      .then((res) => {
        this.decisionBranchModels = res.data.map((d) => {
          return new DecisionBranch(d);
        });
      });
  }

  fetchQuestions() {
    const { id, botId } = this.attrs;
    return axios.get(`/bots/${botId}/answers/${id}/question_answers.json`)
      .then((res) => {
        this.questions = res.data.map((d) => new Question(d));
      });
  }

  update(attrs) {
    const newAttrs = snakeCaseKeys(assign({}, this.attrs, attrs));
    const { botId, id } = this.attrs;
    return axios.put(`/bots/${botId}/answers/${id}.json`, {
      answer: newAttrs,
      authenticity_token: authenticityToken(),
    }).then((res) => {
      return new Answer(res.data);
    });
  }

  delete() {
    const { botId, id } = this.attrs;
    return axios.delete(`/bots/${botId}/answers/${id}.json`, {
      headers: {
        "X-CSRF-Token": authenticityToken(),
      },
    });
  }
}
