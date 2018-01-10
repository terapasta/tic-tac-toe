import { createAction } from 'redux-actions';

export const openNode = createAction('OPEN_NODE');
export const closeNode = createAction('CLOSE_NODE');
export const toggleNode = createAction('TOGGLE_NODE');

export const setActiveItem = createAction('SET_ACTIVE_ITEM');
export const rejectActiveItem = createAction('REJECT_ACTIVE_ITEM');
