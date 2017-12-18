export const Namespace = 'MyOpeChatWidget'
export const MobileMaxWidth = 767;
export const Position = {
  Left: 'left',
  Right: 'right',
  from (literal) {
    if (literal === this.Left) {
      return this.Left
    } else if (literal === this.Right) {
      return this.Right
    }
  }
}
export const MaxHeight = 500
export const Margin = 20
export const MoveButtonSize = 24
export const MoveButtonMargin = 10