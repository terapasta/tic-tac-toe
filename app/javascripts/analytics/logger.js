export default class Logger {
  constructor(label) {
    this.label = label;
  }

  log(message, ...args) {
    if (window.console == null) { return; }
    const stringifiedArgs = args.map((arg) => JSON.stringify(arg)).join(" ");
    console.log(`[${this.label}] ${new Date()}: ${message} ${stringifiedArgs}`);
  }
}
