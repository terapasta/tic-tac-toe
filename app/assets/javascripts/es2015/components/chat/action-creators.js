import { createAction } from "redux-actions";
import trim from "lodash/trim";
import isEmpty from "is-empty";
import toastr from "toastr";
import * as API from "../../api/chat-messages";

export const fetchMessages = createAction("FETCH_MESSAGES", API.fetchMessages);

export const postMessage = createAction("POST_MESSAGE", (token, messageBody) => {
  return new Promise((resolve, reject) => {
    const m = trim(messageBody);
    if (isEmpty(m)) {
      reject(toastr.warning("メッセージを入力してください"));
    } else {
      resolve(API.postMessage(token, messageBody));
    }
  });
});

export const changeMessageBody = createAction("CHANGE_MESSAGE_BODY");
export const clearMessageBody = createAction("CLEAR_MESSAGE_BODY");
