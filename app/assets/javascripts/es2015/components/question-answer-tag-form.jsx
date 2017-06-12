import React, { Component, PropTypes } from "react";
import find from "lodash/find";
import get from "lodash/get";
import isEmpty from "is-empty";

import * as TopicTaggingAPI from "../api/topic-tagging";
import * as TopicTagAPI from "../api/topic-tag";

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
    };
    this.onChangeCheckBox = this.onChangeCheckBox.bind(this);
    this.onSubmitForm = this.onSubmitForm.bind(this);
    this.onChangeInputText = this.onChangeInputText.bind(this);
  }

  componentDidMount() {
    this.findAllTopicTaggings();
    this.findAllTopicTags();
  }

  render() {
    const { topicTaggings, topicTags, deletedTopicTaggings, newTopicTagName } = this.state;

    return (
      <div>
        <div className="form-group">
          <div className="panel panel-default">
            <div className="panel-heading">
              <div className="panel-title">トピックタグ</div>
            </div>
            <div className="panel-body">
              {topicTags.map((t, i) => {
                const tt = find(topicTaggings, (tt) => tt.topicTagId === t.id);
                const baseName = `question_answer[topic_taggings_attributes][${uniqueKey()}]`;
                return (
                  <div key={i}>
                    <label>
                      {get(tt, "id") != null && <input type="hidden" name={`${baseName}[id]`} value={tt.id} />}
                      <input type="checkbox" checked={!isEmpty(tt)} onChange={(e) => this.onChangeCheckBox(t, e)} name={`${baseName}[topic_tag_id]`} value={t.id} />
                      {" "}
                      <span className="label label-primary">{t.name}</span>
                    </label>
                  </div>
                );
              })}
              {isEmpty(topicTags) && (
                <p>トピックタグはありません</p>
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
            <div className="panel-footer">
              <form className="form-inline" onSubmit={this.onSubmitForm}>
                <input type="text" className="form-control" placeholder="トピックタグを追加" onChange={this.onChangeInputText} value={newTopicTagName} />
                <input type="submit" className="btn btn-primary" value="追加" />
              </form>
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

  onSubmitForm(e) {
    e.preventDefault();
    e.stopPropagation();
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
}
