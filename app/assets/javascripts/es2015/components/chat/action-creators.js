import { createAction } from "redux-actions";
import trim from "lodash/trim";
import isEmpty from "is-empty";
import toastr from "toastr";
import * as API from "../../api/chat-messages";
import * as c from "./constants";

export const fetchMessages = createAction("FETCH_MESSAGES", API.fetchMessages);
export const createdMessage = createAction("CREATED_MESSAGE");

export const postMessageIfNeeded = (token, messageBody) => {
  const m = trim(messageBody);
  return (dispatch, getState) => {
    if (isEmpty(m)) { return toastr.warning(c.ErrorPostMessage) }
    postMessage(token, m, dispatch);
  };
};

export function postMessage(token, messageBody, dispatch) {
  API.postMessage(token, messageBody)
    .then((res) => dispatch(createdMessage(res)))
    .then(() => dispatch(clearMessageBody()))
    .catch((err) => {
      console.error(err);
      toastr.error(c.ErrorCreateMessage, c.ErrorTitle);
    });
}

export const changeMessageBody = createAction("CHANGE_MESSAGE_BODY");
export const clearMessageBody = createAction("CLEAR_MESSAGE_BODY");
