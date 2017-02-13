import camelCase from "lodash/camelCase";
import parseJSON from "./parse-json";

export default function getData(el, ignoreKeyword) {
  let data = {};
  [].forEach.call(el.attributes, (attr) => {
    const { name, value } = attr;
    if (new RegExp(`^data\-(?!${ignoreKeyword})`).test(name)) {
      const dataName = camelCase(name.replace(/^data\-/, ""));
      data[dataName] = parseJSON(value);
    }
  });
  return data;
}
