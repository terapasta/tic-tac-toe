import {
  loadItem,
  saveItem,
} from './webStorage';

// Storage key for guest key
const SKGuestKey = 'guest_key';

export function getGuestKey() {
  return loadItem(SKGuestKey);
}

export function setGuestKey(value) {
  saveItem(SKGuestKey, value);
}
