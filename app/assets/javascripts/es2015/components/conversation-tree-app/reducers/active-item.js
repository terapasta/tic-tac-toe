import { handleActions } from 'redux-actions';
import assign from 'lodash/assign';
import { setActiveItem } from '../action-creators';

const initialState = { type: null, nodeKey: null, node: {} };

export default handleActions({
  [setActiveItem]: (state, action) => {
    return assign({}, state, action.payload);
  },
}, initialState);
