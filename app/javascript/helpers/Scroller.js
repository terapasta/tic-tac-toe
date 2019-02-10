export default class Scroller {
  constructor (el, duration) {
    this.el = el
    this.duration = duration
    this.increment = 20
  }

  scrollTo (destination) {
    const start = this.el.scrollTop
    const distance = destination - start
    let currentTime = 0

    const animate = () => {
      currentTime += this.increment
      const val = this.easeInOutQuad(currentTime, start, distance, this.duration)
      this.el.scrollTop = val
      if (currentTime < this.duration) {
        requestAnimationFrame(animate)
      }
    }
    animate()
  }

  easeInOutQuad (t, b, c, d) {
    t /= d/2;
    if (t < 1) {
      return c/2*t*t + b
    }
    t--;
    return -c/2 * (t*(t-2) - 1) + b;
  }
}