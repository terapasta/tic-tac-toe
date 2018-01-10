import React, { Component } from 'react';
import PropTypes from 'prop-types'
import isEmpty from 'is-empty';
import bindAll from 'lodash/bindAll';

import WordMappingForm from './WordMappingForm';

export const searchQueryParam = () => (
  window.location.search
    .replace(/^\?/, '')
    .split('&')
    .map(pair => pair.split('='))
    .reduce((acc, pair) => {
      acc[window.decodeURIComponent(pair[0])] = window.decodeURIComponent(pair[1]);
      return acc;
    }, {})['q']
);

class WordMappings extends Component {
  constructor(props) {
    super(props);
    this.state = {
      wordMappings: props.wordMappings,
      isAdding: false,
      searchQuery: searchQueryParam(),
    };
    bindAll(this, ['handleCreate']);
  }

  handleCreate(wordMapping) {
    const wordMappings = [
      ...[wordMapping],
      ...this.state.wordMappings,
    ];
    this.setState({ wordMappings, isAdding: false });
  }

  render() {
    const { botId, formActionUrl } = this.props;
    const { isAdding, wordMappings, searchQuery } = this.state;

    return (
      <div>
        <div className="d-flex justify-content-between bg-faded mb-3 p-2">
          <div className="pull-left">
            <form action={formActionUrl} className="form-inline">
              <div className="input-group">
                <input
                  type="search"
                  name="q"
                  className="form-control"
                  placeholder="キーワード検索"
                  defaultValue={searchQuery}
                />
                <div className="input-group-btn">
                  <input type="submit" className="btn btn-default btn-secondary" value="検索" />
                </div>
              </div>
              &nbsp;
              {!isEmpty(searchQueryParam()) && (
                <a href={formActionUrl}>
                  <i className="material-icons">close</i>
                  検索を解除
                </a>
              )}
            </form>
          </div>
          <div className="pull-right">
            {!isAdding && (
              <button
                className="btn btn-success"
                onClick={() => this.setState({ isAdding: true })}
              >
                <i className="material-icons mi-v-top">add_circle</i>
                &nbsp;
                辞書を追加
              </button>
            )}
          </div>
        </div>

        {isAdding && (
          <WordMappingForm
            botId={botId}
            onCreate={this.handleCreate}
          />
        )}

        {wordMappings.map((wordMapping) => (
          <WordMappingForm
            key={wordMapping.id}
            botId={botId}
            {...wordMapping}
          />
        ))}
        {isEmpty(wordMappings) && !isAdding && (
          <div className="dict">
            {isEmpty(searchQuery) && (
              <p>まだ辞書は登録されていません</p>
            )}
            {!isEmpty(searchQuery) && (
              <p>辞書データが見つかりませんでした</p>
            )}
          </div>
        )}
      </div>
    );
  }
}

WordMappings.componentName = 'WordMappings';

WordMappings.propTypes = {
  formActionUrl: PropTypes.string.isRequired,
  botId: PropTypes.number,
  wordMappings: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number.isRequired,
    word: PropTypes.string.isRequired,
    synonyms: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number.isRequired,
      value: PropTypes.string.isRequired,
    })),
  })),
};

WordMappings.defaultProps = {
  botId: null,
  wordMappings: [],
};

export default WordMappings;
