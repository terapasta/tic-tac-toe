import * as t from "../action-types";

export default function activeItem(state = { dataType: null, id: null }, action) {
  const { type, dataType, id } = action;

  switch(type) {
    case t.SET_ACTIVE_ITEM:
      return { dataType, id };
    case t.CLEAR_ACTIVE_ITEM:
      return {};
    default:
      return state;
  }
}
