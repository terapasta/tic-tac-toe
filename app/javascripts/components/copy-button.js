import copyToClipboard from "copy-to-clipboard";

export default class CopyButton {
  static initialize() {
    const nodes = [].slice.call(document.querySelectorAll("[data-role='copy-button']"));
    nodes.forEach((node) => {
      new CopyButton(node);
    });
  }

  constructor(node) {
    this.node = node;
    this.bindClickButton();
  }

  bindClickButton() {
    this.node.addEventListener("click", (e) => {
      e.preventDefault();
      const target = document.querySelector(this.node.getAttribute("data-target"));
      if (target == null) { return; }
      this.copyFromNode(target);
    });
  }

  copyFromNode(target) {
    let text;
    switch (target.tagName) {
      case "TEXTAREA":
      case "INPUT":
        text = target.value;
        target.select();
        break;
      default:
        text = target.textContent;
        break;
    }
    copyToClipboard(text);
    this.showMessageAfterButton("コピーしました!!", { lifetime: 5000 });
  }

  showMessageAfterButton(text, options = {}) {
    const message = document.createElement("span");
    message.textContent = " " + text;
    message.setAttribute("class", "text-success");

    const next = this.node.nextSibling;
    if (next == null) {
      this.node.parentNode.appendChild(message);
    } else {
      this.node.parentNode.insertBefore(message, next);
    }

    clearTimeout(this.timerID);
    this.timerID = setTimeout(() => {
      message.remove();
    }, options.lifetime || 2000);
  }
}
