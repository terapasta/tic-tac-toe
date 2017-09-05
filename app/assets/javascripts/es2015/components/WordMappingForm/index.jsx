import React, { Component, PropTypes } from 'react';
import bindAll from 'lodash/bindAll';
import get from 'lodash/get';
import findIndex from 'lodash/findIndex';
import assign from 'lodash/assign';
import isEqual from 'lodash/isEqual';
import isEmpty from 'is-empty';
import compact from 'lodash/compact';
import last from 'lodash/last';

import * as WordMappingAPI from '../../api/word-mappings';
import Alert from '../Alert';

import {
  Wrapper,
  Title,
  SubTitle,
  Words,
  Word,
  EnterToSaveText,
  Input,
} from './elements';

import EditingSynonym from './EditingSynonym';
import EditingWord from './EditingWord';

class WordMappingForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      word: props.word,
      synonyms: props.synonyms,
      editingSynonym: null,
      editingSynonymValue: '',
      isEditingWord: false,
      alertMessage: null,
      addingSynonymValue: '',
      isConfirmDeleteWord: false,
      isDeletedWord: false,
    };
    bindAll(this, [
      'handleClickSynonym',
      'handleSaveEditingSynonym',
      'handleDeleteEditingSynonym',
      'handleSubmitAddingSynonym',
      'handleSaveEditingWord',
      'handleDeleteEditingWord',
      'handleXHRError',
      'handleCreateWord',
    ]);
  }

  handleXHRError(err) {
    let { error, errors } = err.response.data;
    if (!isEmpty(errors)) {
      error = compact([error, ...errors]).join("\n");
    }
    this.setState({ alertMessage: error });
  }

  handleClickSynonym(synonym) {
    this.setState({
      editingSynonym: synonym,
      editingSynonymValue: synonym.value,
      isAddingSynonym: false,
    });
  }

  handleSaveEditingSynonym(synonymId, value) {
    const { botId, id } = this.props;
    const { synonyms, editingSynonym } = this.state;
    if (isEmpty(value)) { return; }

    WordMappingAPI.updateWordMappingSynonym(botId, id, synonymId, { value })
      .then((res) => {
        const index = findIndex(synonyms, (s) => s.id === synonymId);
        synonyms.splice(index, 1, assign({}, editingSynonym, { value }));
        this.setState({
          synonyms,
          editingSynonym: null,
        });
      }).catch(this.handleXHRError);
  }

  handleDeleteEditingSynonym(e) {
    const { botId, id } = this.props;
    const { editingSynonym, synonyms } = this.state;
    this.setState({ isConfirmDeleteEditingSynonym: false });

    WordMappingAPI.deleteWordMappingSynonym(botId, id, editingSynonym.id)
      .then((res) => {
        const newSynonyms = synonyms.filter((s) => s.id !== editingSynonym.id);
        this.setState({
          synonyms: newSynonyms,
          editingSynonym: null,
        });
      }).catch(this.handleXHRError);
  }

  handleSubmitAddingSynonym(e) {
    e.preventDefault();
    const { botId, id } = this.props;
    const { addingSynonymValue, synonyms } = this.state;
    if (isEmpty(addingSynonymValue)) { return; }

    WordMappingAPI.createWordMappingSynonym(botId, id, { value: addingSynonymValue })
      .then((res) => {
        const newSynonym = last(get(res, 'data.wordMapping.synonyms'));
        const newSynonyms = synonyms.concat([newSynonym]);
        this.setState({
          synonyms: newSynonyms,
          isAddingSynonym: false,
          addingSynonymValue: null,
        });
      }).catch(this.handleXHRError);
  }

  handleSaveEditingWord(word) {
    const { botId, id } = this.props;
    WordMappingAPI.updateWordMapping(botId, id, { word })
      .then((res) => this.setState({
        word: get(res, 'data.wordMapping.word'),
        isEditingWord: false,
      }))
      .catch(this.handleXHRError);
  }

  handleDeleteEditingWord() {
    const { botId, id } = this.props;
    WordMappingAPI.deleteWordMapping(botId, id)
      .then((res) => this.setState({
        isDeleted: true,
        isConfirmDeleteWord: false,
      }))
      .catch(this.handleXHRError);
  }

  handleCreateWord(word) {
    const { botId } = this.props;

    WordMappingAPI.createWordMapping(botId, { word })
      .then((res) => {
        const { wordMapping } = res.data;
        const { onCreate } = this.props;
        if (typeof onCreate === 'function') {
          onCreate(wordMapping);
        }
      }).catch(this.handleXHRError);
  }

  render() {
    const { id } = this.props;
    const {
      word,
      synonyms,
      editingSynonym,
      isAddingSynonym,
      isConfirmDeleteEditingSynonym,
      alertMessage,
      isEditingWord,
      isConfirmDeleteWord,
      isDeleted,
    } = this.state;

    if (isDeleted) { return <span />; }

    return (
      <Wrapper id={`dict-${id}`}>
        <Title editing={isEditingWord}>
          {(!isEditingWord && !isEmpty(id)) && (
            <span>
              {word}
              &nbsp;
              <button onClick={() => this.setState({ isEditingWord: true })}>
                <i className="material-icons mi-v-baseline">edit</i>
              </button>
            </span>
          )}
          {isEditingWord && (
            <EditingWord
              defaultValue={word}
              onClose={() => this.setState({ isEditingWord: false })}
              onSubmit={this.handleSaveEditingWord}
              onDelete={() => this.setState({ isConfirmDeleteWord: true })}
            />
          )}
          {isEmpty(id) && (
            <EditingWord
              onSubmit={this.handleCreateWord}
            />
          )}
        </Title>
        {!isEmpty(id) && (
          <span>
            <SubTitle>同じ意味の単語</SubTitle>
            <Words>
              {isEmpty(synonyms) && !isAddingSynonym && (
                <Word noBorder>まだ登録されていません</Word>
              )}
              {synonyms.map((synonym) => {
                if (!isEmpty(editingSynonym) && isEqual(editingSynonym, synonym)) {
                  return (
                    <EditingSynonym
                      key={synonym.id}
                      synonym={synonym}
                      onSave={this.handleSaveEditingSynonym}
                      onClose={() => this.setState({ editingSynonym: null })}
                      onDelete={() => this.setState({ isConfirmDeleteEditingSynonym: true })}
                    />
                  );
                }
                return (
                  <Word
                    key={synonym.id}
                    onClick={() => this.handleClickSynonym(synonym)}
                  >{synonym.value}</Word>
                );
              })}
              {isEmpty(editingSynonym) && !isAddingSynonym && (
                <Word noBorder>
                  <button onClick={() => this.setState({ isAddingSynonym: true })}>
                    <i className="material-icons">add_circle</i>
                  </button>
                </Word>
              )}
              {isAddingSynonym && (
                <Word noBorder noPadding>
                  <form onSubmit={this.handleSubmitAddingSynonym}>
                    <Input
                      type="text"
                      placeholder="単語を追加"
                      onChange={(e) => this.setState({ addingSynonymValue: e.target.value })}
                      autoFocus
                    />
                  </form>
                  &nbsp;
                  <button onClick={() => this.setState({ isAddingSynonym: false })}>
                    <i className="material-icons">close</i>
                  </button>
                  <EnterToSaveText />
                </Word>
              )}
            </Words>
          </span>
        )}
        {isConfirmDeleteEditingSynonym && (
          <Alert
            title="確認"
            subtitle="本当に削除してよろしいですか？"
            onCancel={() => this.setState({ isConfirmDeleteEditingSynonym: false })}
            onOK={this.handleDeleteEditingSynonym}
          />
        )}
        {isConfirmDeleteWord && (
          <Alert
            title="確認"
            subtitle="本当に削除してよろしいですか？同じ意味の単語も全て削除され、この操作は元に戻せません。"
            onCancel={() => this.setState({ isConfirmDeleteWord: false })}
            onOK={this.handleDeleteEditingWord}
          />
        )}
        {!isEmpty(alertMessage) && (
          <Alert
            title="エラー"
            subtitle={alertMessage}
            onOK={() => this.setState({ alertMessage: null })}
          />
        )}
      </Wrapper>
    );
  }
}

WordMappingForm.componentName = 'WordMappingForm';

WordMappingForm.propTypes = {
  botId: PropTypes.number,
  id: PropTypes.number,
  word: PropTypes.string,
  synonyms: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number.isRequired,
    value: PropTypes.string.isRequired,
  })),
  onCreate: PropTypes.func,
};

WordMappingForm.defaultProps = {
  botId: null,
  id: null,
  word: '',
  synonyms: [],
  onCreate: null,
};

export default WordMappingForm;
