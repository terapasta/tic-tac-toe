export default function queryParams () {
  return window.location.search
    .replace(/^\?/, '')
    .split('&')
    .map(it => it.split('='))
    .filter(it => it[1] != null)
    .reduce((acc, pair) => {
      acc[pair[0]] = decodeURIComponent(pair[1])
      return acc
    }, {})
}