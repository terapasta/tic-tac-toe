import sanitizeHtml from 'sanitize-html'
import isEmpty from 'is-empty'

export default {
  methods: {
    highlight (text, query) {
      if (isEmpty(query)) { return text }
      const pattern = new RegExp(query, 'g')
      const tag = `<span class="text-highlight">${query}</span>`
      return sanitizeHtml(text).replace(pattern, tag)
    }
  }
}