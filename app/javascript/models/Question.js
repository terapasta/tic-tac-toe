import axios from 'axios'
import assign from 'lodash/assign'

import authenticityToken from '../helpers/authenticityToken'
import snakeCaseKeys from '../helpers/snakeCaseKeys'

export default class Question {
  static fetch(botId, id) {
    return axios.get(`/bots/${botId}/question_answers/${id}.json`)
      .then((res) => {
        return new Question(assign({ botId }, res.data));
      });
  }

  static create(botId, attrs) {
    return axios.post(`/bots/${botId}/question_answers.json`, {
        question_answer: attrs,
        authenticity_token: authenticityToken(),
      })
      .then((res) => {
        return new Question(assign({ botId }, res.data));
      });
  }

  constructor(attrs = {}) {
    this.attrs = attrs;
  }

  get id() { return this.attrs.id; }
  get question() { return this.attrs.question; }
  get answer() { return this.attrs.answer; }
  get botId() { return this.attrs.botId; }
  get editPath() {
    return `/bots/${this.botId}/question_answers/${this.id}/edit`;
  }
  get topicTags() { return this.attrs.topicTags; }

  update(attrs) {
    const newAttrs = snakeCaseKeys(assign({}, this.attrs, attrs));
    const { botId, id } = this.attrs;
    return axios.put(`/bots/${botId}/question_answers/${id}.json`, {
      question_answer: newAttrs,
      authenticity_token: authenticityToken(),
    }).then((res) => {
      return new Question(assign({ botId }, res.data));
    });
  }

  delete() {
    const { botId, id } = this.attrs;
    return axios.delete(`/bots/${botId}/question_answers/${id}.json`, {
      headers: {
        "X-CSRF-Token": authenticityToken(),
      },
    });
  }
}
