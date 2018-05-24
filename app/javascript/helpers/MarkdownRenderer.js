import marked from 'marked'
import times from 'lodash/times'
import constant from 'lodash/constant'

const renderer = new marked.Renderer()

renderer.heading = (text, level) => {
  return `${times(level, constant('#')).join('')} ${text}`
}

export default renderer
