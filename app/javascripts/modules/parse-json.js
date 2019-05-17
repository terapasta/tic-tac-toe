export default function parseJSON(string) {
  try {
    return JSON.parse(string);
  } catch (e) {
    return string;
  }
}
