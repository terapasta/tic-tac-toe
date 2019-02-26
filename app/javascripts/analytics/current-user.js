export default class CurrentUser {
  constructor() {
    this.data = window.currentUser;
  }

  isExists() {
    return !!this.data;
  }

  get id() { return this.data.id; }
  get email() { return this.data.email; }
}
