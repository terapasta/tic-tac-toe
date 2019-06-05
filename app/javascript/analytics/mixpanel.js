import Logger from "./logger";
import CurrentUser from "./currentUser";
import Trackable from "./trackable";

const getElements = selector => [].slice.call(document.querySelectorAll(selector));

export const makeEvent = elOrEventName => {
  let eventName;
  if (typeof elOrEventName === 'string') {
    eventName = elOrEventName;
  } else {
    eventName = elOrEventName.getAttribute('data-event');
  }

  const options = {};
  if (window.currentBot) {
    const { id, name } = window.currentBot;
    options.bot_id = id;
    options.bot_name = name;
  }
  return { eventName, options };
};

const listenAll = (els, eventName, makeHandler) => {
  els.forEach((el) => {
    el.addEventListener(eventName, makeHandler(el));
  });
};

class MixpanelNullObject {
  initMixpanel() {
    console.warn('The method `Mixpanel#initMixpanel` was called but it\'s not initialized.')
  }

  setupProfile() {
    console.warn('The method `Mixpanel#setupProfile` was called but it\'s not initialized.')
  }

  bindClickLinkEvent() {
    console.warn('The method `Mixpanel#bindClickLinkEvent` was called but it\'s not initialized.')
  }

  bindSubmitFormEvent() {
    console.warn('The method `Mixpanel#bindSubmitFormEvent` was called but it\'s not initialized.')
  }

  track() {
    console.warn('The method `Mixpanel#track` was called but it\'s not initialized.')
  }

  trackForm() {
    console.warn('The method `Mixpanel#trackForm` was called but it\'s not initialized.')
  }

  trackEvent() {
    console.warn('The method `Mixpanel#trackEvent` was called but it\'s not initialized.')
  }
}

export default class Mixpanel {
  static listenEvents() {
    const links = getElements('a[data-event]');
    const buttons = getElements('button[data-event]');
    const inputButtons = getElements('input[type="submit"][data-event]');
    const clickables = [...links, ...buttons, ...inputButtons];
    const checkboxes = getElements('input[type="checkbox"][data-event]');

    const makeHandler = (el) => ((e) => {
      const { eventName, options } = makeEvent(el);
      Mixpanel.sharedInstance.trackEvent(eventName, options);
    });

    listenAll(clickables, 'click', makeHandler);
    listenAll(checkboxes, 'change', makeHandler);
  }

  static initialize(token) {
    this.__sharedInstance = new Mixpanel(token);
  }

  static get sharedInstance () {
    if (this.__sharedInstance) {
      return this.__sharedInstance
    }
    return new MixpanelNullObject()
  }

  constructor(token) {
    this.logger = new Logger("Mixpanel");
    if (window.mixpanel == null) { return; }
    this.initMixpanel(token);
    this.setupProfile();
    // this.bindClickLinkEvent();
    // this.bindSubmitFormEvent();
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
        const trackable = new Trackable(e.target);
        if (trackable.isRemote) {
          trackable.bindAjaxSuccess(() => this.track(trackable));
        } else {
          this.track(trackable);
        }
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
    if (!trackable.isTrackable) { return; }
    const { eventName, options } = trackable;
    this.trackEvent(eventName, options);
  }

  trackForm(trackable) {
    if (!trackable.isTrackable) { return; }
    const { id, eventName, options } = trackable;
    if (trackable.isRemote) {
      trackable.bindAjaxSuccess(() => this.track(trackable));
    } else {
      mixpanel.track_forms(`#${id}`, eventName, options);
    }
  }

  trackEvent(eventName, options) {
    this.logger.log("track", eventName, options);
    if (window.mixpanel == null) { return; }
    mixpanel.track(eventName, options);
  }
}
