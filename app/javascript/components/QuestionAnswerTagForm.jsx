import React, { Component } from "react";
import PropTypes from 'prop-types'
import find from "lodash/find";
import get from "lodash/get";
import isEmpty from "is-empty";

import queryParams from '../helpers/queryParams'
import Mixpanel, { makeEvent } from '../analytics/mixpanel';
import * as TopicTaggingAPI from "../api/topicTagging";
import * as TopicTagAPI from "../api/topicTag";

function uniqueKey() {
  return Math.floor(new Date().getTime() * Math.random());
}

export default class QuestionAnswerTagFrom extends Component {
  static get componentName() {
    return "QuestionAnswerTagForm";
  }

  static get propTypes() {
    return {
      qustionAnswerId: PropTypes.number,
      botId: PropTypes.number.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      topicTags: [],
      topicTaggings: [],
      deletedTopicTaggings: [],
      newTopicTagName: "",
      onlyEditableSubQuestion: !isEmpty(queryParams().only_editable_sub_question)
    };
    this.onChangeCheckBox = this.onChangeCheckBox.bind(this);
    this.onChangeInputText = this.onChangeInputText.bind(this);
    this.onClickButton = this.onClickButton.bind(this);
    this.handleTopicTagsLink = this.handleTopicTagsLink.bind(this);
  }

  componentDidMount() {
    this.findAllTopicTaggings();
    this.findAllTopicTags();
  }

  render() {
    const { topicTaggings, topicTags, deletedTopicTaggings, newTopicTagName, onlyEditableSubQuestion } = this.state;

    return (
      <div>
        <div className="form-group">
          <div className="card">
            <div className="card-body">
              <div className="d-flex justify-content-between">
                <label>トピックタグ</label>
                &nbsp;&nbsp;
                <a href={`/bots/${window.currentBot.id}/topic_tags`} target="_blank" onClick={this.handleTopicTagsLink}>
                  <i className="material-icons mi-xs mi-label-rotate">label</i>
                  <span>トピックタグ管理はこちら</span>
                </a>
              </div>
              {topicTags.map((t, i) => {
                const tt = find(topicTaggings, (tt) => tt.topicTagId === t.id);
                const baseName = `question_answer[topic_taggings_attributes][${uniqueKey()}]`;
                return (
                  <div key={i}>
                    <label>
                      {get(tt, "id") != null && <input type="hidden" name={`${baseName}[id]`} value={tt.id} />}
                      <input
                        id={`topic-tag-${get(t, 'id')}`}
                        type="checkbox"
                        checked={!isEmpty(tt)}
                        onChange={(e) => this.onChangeCheckBox(t, e)}
                        name={`${baseName}[topic_tag_id]`}
                        value={t.id}
                        disabled={onlyEditableSubQuestion}
                      />
                      {" "}
                      <span
                        className={`badge ${onlyEditableSubQuestion ? 'badge-secondary' : 'badge-primary'}`}
                      >{t.name}</span>
                    </label>
                  </div>
                );
              })}
              {isEmpty(topicTags) && (
                <p className="mb-0">トピックタグはありません</p>
              )}
              {deletedTopicTaggings.map((dtt, i) => {
                const baseName = `question_answer[topic_taggings_attributes][${uniqueKey()}]`;
                return (
                  <span key={i}>
                    <input type="hidden" name={`${baseName}[id]`} value={dtt.id} />
                    <input type="hidden" name={`${baseName}[_destroy]`} value="1" />
                  </span>
                );
              })}
            </div>
            <div className="card-footer">
              <div className="input-group">
                <input id="topic-tag-name" type="text" className="form-control form-control-sm" placeholder="トピックタグを追加" onChange={this.onChangeInputText} value={newTopicTagName} disabled={onlyEditableSubQuestion} />
                <span className="input-group-btn">
                  <button className="btn btn-primary" onClick={this.onClickButton} disabled={onlyEditableSubQuestion}>追加</button>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  findAllTopicTaggings() {
    const { questionAnswerId, botId } = this.props;
    if (questionAnswerId == null) { return; }
    TopicTaggingAPI.findAll(botId, questionAnswerId).then((res) => {
      const { topicTaggings } = res.data;
      this.setState({ topicTaggings });
    }).catch(console.error);
  }

  findAllTopicTags() {
    const { botId } = this.props;
    TopicTagAPI.findAll(botId).then((res) => {
      const { topicTags } = res.data;
      this.setState({ topicTags });
    }).catch(console.error);
  }

  onChangeCheckBox(topicTag, e) {
    const { checked } = e.target;
    const { topicTaggings, deletedTopicTaggings } = this.state;
    let newTopicTaggings, newDeletedTopicTaggings = deletedTopicTaggings.concat();

    if (checked) {
      const deletedTopicTagging = find(deletedTopicTaggings, (dtt) => dtt.topicTagId === topicTag.id);
      if (deletedTopicTagging != null) {
        // 登録済みのtaggingを一回削除しもとに戻した場合
        newDeletedTopicTaggings = deletedTopicTaggings.filter((tt) => tt.topicTagId !== topicTag.id);
        newTopicTaggings = topicTaggings.concat(deletedTopicTagging);
      } else {
        // 新規で選択した場合
        newTopicTaggings = topicTaggings.concat({ topicTagId: topicTag.id });
      }
    } else {
      // チェックボックスをはずす
      newTopicTaggings = topicTaggings.filter((tt) => tt.topicTagId !== topicTag.id);

      const targetTT = find(topicTaggings, (tt) => tt.topicTagId === topicTag.id);
      if (get(targetTT, "id") != null) {
        // 登録済みのtaggingだったら_destroyを渡せるようにする
        newDeletedTopicTaggings = deletedTopicTaggings.concat({
          id: targetTT.id,
          topicTagId: topicTag.id,
        });
      }
    }

    this.setState({
      topicTaggings: newTopicTaggings,
      deletedTopicTaggings: newDeletedTopicTaggings,
    });
  }

  createTag() {
    const { botId } = this.props;
    const { topicTags, newTopicTagName } = this.state;

    if (isEmpty(newTopicTagName)) { return; }
    if (find(topicTags, (t) => t.name === newTopicTagName) != null) {
      return window.alert("既に登録されているトピックタグです");
    }

    TopicTagAPI.create(botId, { name: newTopicTagName }).then((res) => {
      const { topicTags } = this.state;
      const newTopicTags = topicTags.concat([res.data.topicTag]);
      this.setState({ topicTags: newTopicTags, newTopicTagName: "" });
    }).catch(console.error);
  }

  onChangeInputText(e) {
    this.setState({ newTopicTagName: e.target.value });
  }

  onClickButton(e) {
    e.preventDefault();
    e.stopPropagation();
    this.createTag();
    const { eventName, options } = makeEvent('add to topic tag');
    Mixpanel.sharedInstance.trackEvent(eventName, options);
  }

  handleTopicTagsLink() {
    const { eventName, options } = makeEvent('control topic tag');
    Mixpanel.sharedInstance.trackEvent(eventName, options);
  }
}
