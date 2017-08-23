import React, { Component, PropTypes } from 'react';
import styled from 'styled-components';
import bindAll from 'lodash/bindAll';
import get from 'lodash/get';
import findIndex from 'lodash/findIndex';
import assign from 'lodash/assign';
import isEqual from 'lodash/isEqual';
import isEmpty from 'is-empty';

import setCaretPosition from '../../modules/set-caret-position';
import * as WordMappingAPI from '../../api/word-mappings';
import Modal from '../modal';

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

const setCaretToTail = (input) => {
  if (input == null) { return; }
  setCaretPosition(input, get(input, 'value', '').length);
};

class WordMappingForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      word: props.word,
      synonyms: props.synonyms,
      editingSynonym: null,
      editingSynonymValue: '',
      isAddingSynonym: false,
      alertMessage: null,
      addingSynonymValue: '',
    };
    bindAll(this, [
      'handleClickEditWord',
      'handleClickSynonym',
      'handleChangeEditingSynonym',
      'handleClickCloseEditingSynonym',
      'handleClickAddSynonym',
      'handleClickCloseAddingSynonym',
      'handleSaveEditingSynonym',
      'handleConfirmDeleteEditingSynonym',
      'handleDeleteEditingSynonym',
      'handleChangeAddingSynonym',
      'handleSubmitAddingSynonym',
    ]);
  }

  handleClickEditWord() {
    console.log('handleClickEditWord');
  }

  handleClickSynonym(synonym) {
    this.setState({
      editingSynonym: synonym,
      editingSynonymValue: synonym.value,
      isAddingSynonym: false,
    });
  }

  handleChangeEditingSynonym(e) {
    this.setState({
      editingSynonymValue: e.target.value,
    });
  }

  handleClickCloseEditingSynonym() {
    this.setState({
      editingSynonym: null,
    });
  }

  handleClickAddSynonym() {
    this.setState({
      isAddingSynonym: true,
    });
  }

  handleClickCloseAddingSynonym() {
    this.setState({
      isAddingSynonym: false,
    })
  }

  handleSaveEditingSynonym(e) {
    e.preventDefault();
    const { botId, id } = this.props;
    const { editingSynonymValue, editingSynonym, synonyms } = this.state;
    if (isEmpty(editingSynonymValue)) { return; }

    WordMappingAPI.updateWordMappingSynonym(botId, id, editingSynonym.id, {
      value: editingSynonymValue,
    }).then((res) => {
      const index = findIndex(synonyms, (s) => s.id === editingSynonym.id);
      synonyms.splice(index, 1, assign({}, editingSynonym, {
        value: editingSynonymValue,
      }));
      this.setState({
        synonyms,
        editingSynonym: null,
      });
    })
    .catch((err) => {
      const { error } = err.response.data;
      this.setState({ alertMessage: error });
    });
  }

  handleConfirmDeleteEditingSynonym(e) {
    this.setState({ isConfirmEditingSynonym: true });
  }

  handleDeleteEditingSynonym(e) {
    const { botId, id } = this.props;
    const { editingSynonym, synonyms } = this.state;
    this.setState({ isConfirmEditingSynonym: false });

    WordMappingAPI.deleteWordMappingSynonym(botId, id, editingSynonym.id)
      .then((res) => {
        const newSynonyms = synonyms.filter((s) => s.id !== editingSynonym.id);
        this.setState({
          synonyms: newSynonyms,
          editingSynonym: null,
        });
      }).catch((err) => {
        const { error } = err.response.data;
        this.setState({ alertMessage: error });
      });
  }

  handleChangeAddingSynonym(e) {
    this.setState({
      addingSynonymValue: e.target.value,
    });
  }

  handleSubmitAddingSynonym(e) {
    e.preventDefault();
    const { botId, id } = this.props;
    const { addingSynonymValue, synonyms } = this.state;
    if (isEmpty(addingSynonymValue)) { return; }

    WordMappingAPI.createWordMappingSynonym(botId, id, {
      value: addingSynonymValue,
    }).then((res) => {
      const newSynonyms = synonyms.concat([res.data.wordMappingSynonym]);
      this.setState({
        synonyms: newSynonyms,
        isAddingSynonym: false,
        addingSynonymValue: null,
      });
    }).catch((err) => {
      const { error } = err.response.data;
      this.setState({ alertMessage: error });
    })
  }

  render() {
    const { id } = this.props;
    const {
      word,
      synonyms,
      editingSynonym,
      isAddingSynonym,
      isConfirmEditingSynonym,
      alertMessage,
    } = this.state;

    return (
      <Wrapper id={`dict-${id}`}>
        <Title>
          {word}
          <button onClick={this.handleClickEditWord}>
            <i className="material-icons mi-v-top">edit</i>
          </button>
        </Title>
        <SubTitle>同じ意味の単語</SubTitle>
        <Words>
          {synonyms.map((synonym) => {
            if (!isEmpty(editingSynonym) && isEqual(editingSynonym, synonym)) {
              return <EditingSynonym
                synonym={synonym}
                onSave={this.handleSaveEditingSynonym}
                onClose={() => this.setState({ editingSynonym: null })}
                onDelete={this.handleConfirmDeleteEditingSynonym}
              />
            } else {
              return (
                <Word
                  key={synonym.id}
                  onClick={() => this.handleClickSynonym(synonym)}
                >
                  {synonym.value}
                </Word>
              );
            }
          })}
          {isEmpty(editingSynonym) && !isAddingSynonym && (
            <Word noBorder>
              <button onClick={this.handleClickAddSynonym}>
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
                  onChange={this.handleChangeAddingSynonym}
                  autoFocus
                />
              </form>
              &nbsp;
              <button onClick={this.handleClickCloseAddingSynonym}>
                <i className="material-icons">close</i>
              </button>
              <EnterToSaveText />
            </Word>
          )}
        </Words>
        {isConfirmEditingSynonym && (
          <Modal narrow title="確認">
            <p>本当に削除してよろしいですか？</p>
            <div className="text-right">
              <button
                className="btn btn-default"
                onClick={() => this.setState({ editingSynonym: null, isConfirmEditingSynonym: false })}
              >
                キャンセル
              </button>
              &nbsp;
              <button
                className="btn btn-primary"
                onClick={this.handleDeleteEditingSynonym}
              >OK</button>
            </div>
          </Modal>
        )}
        {!isEmpty(alertMessage) && (
          <Modal narrow title="エラー">
            <p>{alertMessage}</p>
            <div className="text-right">
              <button
                className="btn btn-primary"
                onClick={() => this.setState({ alertMessage: null })}
              >OK</button>
            </div>
          </Modal>
        )}
      </Wrapper>
    );
  }
}

WordMappingForm.componentName = 'WordMappingForm';

WordMappingForm.propTypes = {
  botId: PropTypes.number.isRequired,
  id: PropTypes.number.isRequired,
  word: PropTypes.string.isRequired,
  synonyms: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number.isRequired,
    value: PropTypes.string.isRequired,
  })),
};

export default WordMappingForm;
