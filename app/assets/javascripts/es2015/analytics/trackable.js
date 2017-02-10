export default class Trackable {
  constructor(el) {
    this.el = el;
  }

  isTrackable() {
    return !!this.eventName;
  }

  get eventName() {
    return this.el.getAttribute("data-event-name");
  }

  get options() {
    return getData(this.el, "event-name");
  }
}
