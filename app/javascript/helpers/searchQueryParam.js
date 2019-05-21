export default function searchQueryParam () {
  return window.location.search
    .replace(/^\?/, '')
    .split('&')
    .map(pair => pair.split('='))
    .reduce((acc, pair) => {
      acc[window.decodeURIComponent(pair[0])] = window.decodeURIComponent(pair[1]);
      return acc;
    }, {})['q']
}