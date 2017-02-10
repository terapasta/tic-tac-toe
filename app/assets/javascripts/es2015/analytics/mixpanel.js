import getData from "../modules/get-data";

import Logger from "./logger";
import CurrentUser from "./current-user";
import Trackable from "./trackable";

export default class Mixpanel {
  constructor(token) {
    if (window.mixpanel == null) { return; }
    this.logger = new Logger("Mixpanel");
    this.initMixpanel(token);
    this.setupProfile();
    this.bindClickLinkEvent();
    this.bindSubmitFormEvent();
  }

  initMixpanel(token) {
    mixpanel.init(token, {
      track_links_timeout: 2000,
    });
    this.logger.log("init");
  }

  setupProfile() {
    this.currentUser = new CurrentUser();
    if (!this.currentUser.isExists()) { return; }
    mixpanel.identify(this.currentUser.id);
    mixpanel.people.set({
      "$email": this.currentUser.email,
    });
    this.logger.log("setup profile");
  }

  bindClickLinkEvent() {
    document.addEventListener("click", (e) => {
      try {
        this.track(new Trackable(e.target));
      } catch(e) {
        console.error(e);
      }
    });
    this.logger.log("bind click events");
  }

  bindSubmitFormEvent() {
    [].forEach.call(document.querySelectorAll("form[data-event-name]"), (form) => {
      try {
        this.trackForm(new Trackable(form));
      } catch(e) {
        console.error(e);
      }
    });
  }

  track(trackable) {
    if (!trackable.isTrackable()) { return; }
    const { eventName, options } = trackable;
    mixpanel.track(eventName, options);
    this.logger.log("track", eventName, options);
  }

  trackForm(trackable) {
    if (!trackable.isTrackable()) { return; }
    const { id, eventName, options } = trackable;
    mixpanel.track_forms(`#${id}`, eventName, options);
    this.logger.log("track form", eventName, options);
  }
}
