import isEmpty from 'is-empty'

export default {
  initialSelections (state) {
    const firstMessage = state.messages.find(it => !isEmpty(it.initialSelections))
    if (firstMessage == null) { return [] }
    return firstMessage.initialSelections
  },
}
