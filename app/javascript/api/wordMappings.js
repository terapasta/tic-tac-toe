import axios from 'axios';
import isEmpty from 'is-empty';
import assign from 'lodash/assign';
import config from './config';

export const updateWordMappingSynonym = (botId, wordMappingId, synonymId, data) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings/${wordMappingId}.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings/${wordMappingId}.json`;
  }
  const payload = {
    word_mapping: {
      word_mapping_synonyms_attributes: [assign({}, data, {
        id: synonymId,
      })],
    },
  };
  return axios.put(path, payload, config());
};

export const createWordMappingSynonym = (botId, wordMappingId, data) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings/${wordMappingId}.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings/${wordMappingId}.json`;
  }
  const payload = {
    word_mapping: {
      word_mapping_synonyms_attributes: [data],
    },
  };
  return axios.put(path, payload, config());
}

export const deleteWordMappingSynonym = (botId, wordMappingId, synonymId) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings/${wordMappingId}.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings/${wordMappingId}.json`;
  }
  const payload = {
    word_mapping: {
      word_mapping_synonyms_attributes: [{
        id: synonymId,
        _destroy: true,
      }],
    },
  };
  return axios.put(path, payload, config());
};

export const createWordMapping = (botId, data) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings.json`;
  }
  return axios.post(path, { word_mapping: data }, config());
}

export const updateWordMapping = (botId, wordMappingId, data) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings/${wordMappingId}.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings/${wordMappingId}.json`;
  }
  return axios.put(path, { word_mapping: data }, config());
}

export const deleteWordMapping = (botId, wordMappingId) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings/${wordMappingId}.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings/${wordMappingId}.json`;
  }
  return axios.delete(path, config());
};
