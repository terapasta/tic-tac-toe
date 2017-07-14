import { handleActions } from "redux-actions";
import { setActiveItem } from '../action-creators';

const initialState = { nodeKey: null };

export default handleActions({
  [setActiveItem]: (state, action) => {
    return { nodeKey: action.payload.nodeKey };
  },
}, initialState);
