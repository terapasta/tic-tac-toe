import { createAction } from "redux-actions";
import * as API from "../../api/chat-messages";

export const fetchMessages = createAction("FETCH_MESSAGES", API.fetchMessages);
