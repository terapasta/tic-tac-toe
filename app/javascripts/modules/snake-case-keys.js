import reduce from "lodash/reduce";
import snakeCase from "lodash/snakeCase";

export default function snakeCaseKeys(object) {
  return reduce(object, (result, val, key) => {
    result[snakeCase(key)] = val;
    return result;
  }, {});
}
