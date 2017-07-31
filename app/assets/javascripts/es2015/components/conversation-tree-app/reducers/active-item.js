import { handleActions } from 'redux-actions';
import assign from 'lodash/assign';

import {
  setActiveItem,
  rejectActiveItem,
} from '../action-creators';

const initialState = { type: null, nodeKey: null, node: {} };

export default handleActions({
  [setActiveItem]: (state, action) => {
    return assign({}, state, action.payload);
  },
  [rejectActiveItem]: (state, action) => {
    return initialState;
  },
}, initialState);
