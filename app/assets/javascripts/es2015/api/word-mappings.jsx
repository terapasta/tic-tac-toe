import axios from 'axios';
import config from './config';

export const updateWordMappingSynonym = (botId, wordMappingId, synonymId, data) => {
  const path = `/api/bots/${botId}/word_mappings/${wordMappingId}/synonyms/${synonymId}.json`;
  return axios.put(path, { word_mapping_synonym: data }, config());
};

export const createWordMappingSynonym = (botId, wordMappingId, data) => {
  const path = `/api/bots/${botId}/word_mappings/${wordMappingId}/synonyms.json`;
  return axios.post(path, { word_mapping_synonym: data }, config());
}

export const deleteWordMappingSynonym = (botId, wordMappingId, synonymId) => {
  const path = `/api/bots/${botId}/word_mappings/${wordMappingId}/synonyms/${synonymId}.json`;
  return axios.delete(path, config());
};
