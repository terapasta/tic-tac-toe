import { createAction } from "redux-actions";
import * as API from "../../api/chat-messages";

export const fetchMessages = createAction("FETCH_MESSAGES", API.fetchMessages);

export const changeMessageBody = createAction("CHANGE_MESSAGE_BODY");
