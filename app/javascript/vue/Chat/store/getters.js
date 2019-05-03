export default {
  areMessagePagesRemaining (state) {
    return state.messagePage < state.messageTotalPages
  }
}
