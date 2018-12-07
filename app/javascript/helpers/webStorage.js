import Cookies from 'js-cookie';

export function saveItem(key, value) {
  localStorage.setItem(key, value);
  Cookies.set(key, value);
}

export function loadItem(key) {
  return localStorage.getItem(key) || Cookies.get(key);
}