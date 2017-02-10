import uuid from "uuid/v1";

import getData from "../modules/get-data";

export default class Trackable {
  constructor(el) {
    this.el = el;
  }

  get isTrackable() {
    return !!this.eventName;
  }

  get isRemote() {
    return this.el.getAttribute("data-remote") === "true";
  }

  get id() {
    let _id = this.el.getAttribute("id");
    if (_id == null) {
      _id = uuid();
      this.el.setAttribute("id", _id);
    }
    return _id;
  }

  get eventName() {
    return this.el.getAttribute("data-event-name");
  }

  get options() {
    return getData(this.el, "event-name");
  }
}
