export default function authenticityToken() {
  return (document.querySelector("meta[name='csrf-token']") || {}).content;
}
