import axios from "axios";
import assign from "lodash/assign";

import Answer from "./answer";

import authenticityToken from "../modules/authenticity-token";
import snakeCaseKeys from "../modules/snake-case-keys";

export default class DecisionBranch {
  static fetch(botId, id) {
    return axios.get(`/bots/${botId}/decision_branches/${id}.json`)
      .then((res) => {
        return new DecisionBranch(assign({ botId }, res.data));
      });
  }

  static create(botId, attrs) {
    return axios.post(`/bots/${botId}/decision_branches.json`, {
      decision_branch: attrs,
      authenticity_token: authenticityToken(),
    }).then((res) => {
      return new DecisionBranch(res.data);
    });
  }

  constructor(attrs = {}) {
    this.attrs = attrs;
  }

  get id() { return this.attrs.id; }
  get body() { return this.attrs.body; }
  get nextAnswerId() { return this.attrs.nextAnswerId; }

  fetchNextAnswer() {
    const { botId, nextAnswerId } = this.attrs;
    return axios.get(`/bots/${botId}/answers/${nextAnswerId}.json`)
      .then((res) => {
        this.nextAnswerModel = new Answer(res.data);
      });
  }

  update(attrs) {
    const newAttrs = snakeCaseKeys(assign({}, this.attrs, attrs));
    const { botId, id } = this.attrs;
    return axios.put(`/bots/${botId}/decision_branches/${id}.json`, {
      decision_branch: newAttrs,
      authenticity_token: authenticityToken(),
    }).then((res) => {
      return new DecisionBranch(res.data);
    });
  }

  delete() {
    const { botId, id } = this.attrs;
    return axios.delete(`/bots/${botId}/decision_branches/${id}.json`, {
      headers: {
        "X-CSRF-Token": authenticityToken(),
      },
    });
  }
}
