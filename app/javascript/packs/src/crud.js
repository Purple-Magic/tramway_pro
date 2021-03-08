import axios from 'axios'

const config = {
  development: {
    api: 'http://red-magic.test:3000',
  },
  production: {
    api: 'http://red-magic.ru',
  },
}

const apiUrl = config[process.env.RAILS_ENV || 'development'].api

export const index = (entity, params) => {
  return axios.get(`${apiUrl}/api/v1/records?model=${entity}`, { params })
}

export const show = (entity, id, params = null) => {
  if (params) {
    return axios.get(`${apiUrl}/api/v1/records/${id}?model=${entity}`, { params })
  }
  return axios.get(`${apiUrl}/api/v1/records/${id}?model=${entity}`)
}

export const create = (entity, params) => {
  const bodyFormData = new FormData()
  const args = Object.keys(params)
  args.forEach((arg) => {
    bodyFormData.set(`data[attributes][${arg}]`, params[arg])
  })
  return axios.post(`${apiUrl}/api/v1/records?model=${entity}`, bodyFormData)
}
