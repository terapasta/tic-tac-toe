export default function makeQueryParams (params) {
  const filtered = Object.keys(params).reduce((acc, key) => {
    if (params[key]) {
      return { ...acc, [key]: params[key] }
    }
    return acc
  }, {})

  const pairs = Object.keys(filtered)
    .map(key => `${key}=${encodeURIComponent(filtered[key])}`)
    .join('&')

  return `?${pairs}`
}