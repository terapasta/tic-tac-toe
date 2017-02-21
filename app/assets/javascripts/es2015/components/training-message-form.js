import trim from "lodash/trim";
import toastr from "toastr";

export default class TrainingMessageForm {
  constructor() {
    this.el = document.querySelector("form#new_training_message");
    if (this.el == null) { return; }
    this.bindSubmit();
  }

  bindSubmit() {
    this.el.addEventListener("submit", (e) => {
      const { value } = this.el.querySelector("input[type='text']");
      const trimed = trim(value);
      if (trimed.length == 0) {
        e.preventDefault();
        toastr.warning("メッセージを入力してください");
      }
    });
  }
}
