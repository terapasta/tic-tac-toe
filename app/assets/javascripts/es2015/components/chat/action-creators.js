import { createAction } from "redux-actions";
import assign from "lodash/assign";
import trim from "lodash/trim";
import isEmpty from "is-empty";
import toastr from "toastr";
import * as API from "../../api/chat-messages";
import * as MessageRatingAPI from "../../api/chat-message-rating";
import * as c from "./constants";

import Mixpanel from "../../analytics/mixpanel";
import snakeCaseKeys from "../../modules/snake-case-keys";
export const fetchMessages = createAction("FETCH_MESSAGES", API.fetchMessages);
export const createdMessage = createAction("CREATED_MESSAGE");

export const postMessageIfNeeded = (token, messageBody) => {
  const m = trim(messageBody);
  return (dispatch, getState) => {
    if (isEmpty(m)) { return toastr.warning(c.ErrorPostMessage) }
    if(getState().form.isDisabled) { return; }
    dispatch(disableForm());
    postMessage(token, m, dispatch);
  };
};

export function postMessage(token, messageBody, dispatch) {
  API.postMessage(token, messageBody)
    .then((res) => dispatch(createdMessage(res)))
    .then(() => dispatch(clearMessageBody()))
    .then(() => dispatch(enableForm()))
    .catch((err) => {
      console.error(err);
      toastr.error(c.ErrorCreateMessage, c.ErrorTitle);
    });
}

export const changeMessageBody = createAction("CHANGE_MESSAGE_BODY");
export const clearMessageBody = createAction("CLEAR_MESSAGE_BODY");
export const disableForm = createAction("DISABLE_FORM");
export const enableForm = createAction("ENABLE_FORM");

export function changeMessageRatingTo(type, token, messageId) {
  return (dispatch, getState) => {
    switch (type) {
      case c.Ratings.Good:
        trackMixpanel("Good rating answer", { messageId })
        dispatch(goodMessage(token, messageId));
        break;
      case c.Ratings.Bad:
        trackMixpanel("Bad rating answer", { messageId })
        dispatch(badMessage(token, messageId));
        break;
      case c.Ratings.Nothing:
        trackMixpanel("No rating answer", { messageId })
        dispatch(nothingMessage(token, messageId));
        break;
    }
  };
}

export const goodMessage = createAction("GOOD_MESSAGE", MessageRatingAPI.good);
export const badMessage = createAction("BAD_MESSAGE", MessageRatingAPI.bad);
export const nothingMessage = createAction("NOTHING_MESSAGE", MessageRatingAPI.nothing);

export function trackMixpanel(eventName, options) {
  const { id, name } = window.currentBot;
  const snakeCaseOptions = snakeCaseKeys(options);
  const opt = assign({ bot_id: id, bot_name: name, }, snakeCaseOptions);
  Mixpanel.sharedInstance.trackEvent(eventName, opt);
}
