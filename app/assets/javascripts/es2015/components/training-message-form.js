import trim from "lodash/trim";
import toastr from "toastr";

export default class TrainingMessageForm {
  constructor() {
    this.el = document.querySelector("form#new_training_message");
    if (this.el == null) { return; }
    this.bindSubmit();
    this.isSubmitFromScript = false;
  }

  bindSubmit() {
    this.el.addEventListener("submit", (e) => {
      if (!this.isSubmitFromScript) { e.preventDefault(); }

      const { value } = this.el.querySelector("input[type='text']");
      const trimed = trim(value);

      if (trimed.length == 0) {
        e.preventDefault();
        toastr.warning("メッセージを入力してください");
      } else {
        this.isSubmitFromScript = true;
        this.el.submit();
      }
    });
  }
}
