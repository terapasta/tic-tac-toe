export default function getOffset(elem) {
  if (!elem.getClientRects().length) {
    return { top: 0, left: 0 }
  }
  const rect = elem.getBoundingClientRect()

  if ( rect.width || rect.height ) {
    const doc = elem.ownerDocument
    const win = window
    const docElem = doc.documentElement

    return {
      top: rect.top + win.pageYOffset - docElem.clientTop,
      left: rect.left + win.pageXOffset - docElem.clientLeft
    }
  }

  return rect
}
