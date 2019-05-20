export default function setCaretPosition(el, position) {
  if (el.createTextRange) {
    const range = el.createTextRange();
    range.move('character', position);
    range.select();
  } else {
    if (el.setSelectionRange) {
      el.focus();
      el.setSelectionRange(position, position);
    } else {
      el.focus();
    }
  }
}
