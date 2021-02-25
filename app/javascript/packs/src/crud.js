import axios from 'axios'

const apiUrl = './'

export const index = (entity, params) => {
  return axios.get(`${apiUrl}/${entity}`, { params })
}

export const show = (entity, params) => {
  if (params) {
    return axios.get(`${apiUrl}/${entity}`, { params })
  }
  return axios.get(`${apiUrl}/${entity}`)
}

export const create = (entity, params, args = null) => {
  let updatedArgs = args
  if (!args) {
    updatedArgs = Object.keys(params)
  }
  const bodyFormData = new FormData();
  updatedArgs.forEach((arg) => {
    bodyFormData.set(arg, params[arg])
  })
  return axios.post(`${apiUrl}/${entity}`, bodyFormData)
}
