import assign from "lodash/assign";
import { handleActions } from "redux-actions";
import { changeMessageBody } from "../action-creators";

export default handleActions({
  [changeMessageBody]: (state, action) => {
    if (action.error) {
      return state;
    }

    const { messageBody } = action.payload;

    return assign({}, state, {
      messageBody,
    });
  },
}, {
  messageBody: "",
});
