import assign from "lodash/assign";
import { handleActions } from "redux-actions";
import { fetchMessages } from "../action-creators";

const initialState = {
  data: [],
  totalPages: 0,
};

export default handleActions({
  [fetchMessages]: (state, action) => {
    const { payload } = action;

    if (action.error) {
      console.error(payload);
      return state;
    }

    return assign({}, state, {
      data: state.data.concat(payload.data.messages),
      totalPages: payload.data.total_pages,
    });
  },
}, initialState);
