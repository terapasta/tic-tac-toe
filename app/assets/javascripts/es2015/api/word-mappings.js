import axios from 'axios';
import isEmpty from 'is-empty';
import config from './config';

export const updateWordMappingSynonym = (botId, wordMappingId, synonymId, data) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings/${wordMappingId}/synonyms/${synonymId}.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings/${wordMappingId}/synonyms/${synonymId}.json`;
  }
  return axios.put(path, { word_mapping_synonym: data }, config());
};

export const createWordMappingSynonym = (botId, wordMappingId, data) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings/${wordMappingId}/synonyms.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings/${wordMappingId}/synonyms.json`;
  }
  return axios.post(path, { word_mapping_synonym: data }, config());
}

export const deleteWordMappingSynonym = (botId, wordMappingId, synonymId) => {
  let path;
  if (isEmpty(botId)) {
    path = `/api/word_mappings/${wordMappingId}/synonyms/${synonymId}.json`;
  } else {
    path = `/api/bots/${botId}/word_mappings/${wordMappingId}/synonyms/${synonymId}.json`;
  }
  return axios.delete(path, config());
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
