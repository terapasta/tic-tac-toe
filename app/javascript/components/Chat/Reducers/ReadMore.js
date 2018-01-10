import assign from 'lodash/assign'
import { handleActions } from 'redux-actions'

import {
  appearReadMore,
  disappearReadMore,
  enableReadMore,
  disableReadMore,
} from '../ActionCreators'

export default handleActions({
  [appearReadMore]: (state, action) => {
    return assign({}, state, { isAppered: true })
  },

  [disappearReadMore]: (state, action) => {
    return assign({}, state, { isAppered: false })
  },

  [enableReadMore]: (state, action) => {
    return assign({}, state, { isDisabled: false })
  },

  [disableReadMore]: (state, action) => {
    return assign({}, state, { isDisabled: true })
  },
}, {
  isAppered: false,
  isDisabled: false,
})
