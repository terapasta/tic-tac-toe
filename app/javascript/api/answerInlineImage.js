import axios from 'axios'
import config from './config'

export const upload = ({ botId, file }) => {
  const path = `/api/bots/${botId}/answer_inline_images`
  const formData = new FormData()
  formData.append('answer_inline_image[file]', file)
  return axios.post(path, formData, config())
}
