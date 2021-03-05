import axios from 'axios'

const config = {
  development: {
    api: 'http://it-way.test:3000',
  },
  production: {
    api: 'https://it-way.pro',
  },
}

const apiUrl = config[process.env.RAILS_ENV || 'development'].api

export const index = (entity, params) => {
  return axios.get(`${apiUrl}/${entity}`, { params })
}

export const show = (entity, params) => {
  if (params) {
    return axios.get(`${apiUrl}/${entity}`, { params })
  }
  return axios.get(`${apiUrl}/${entity}`)
}

export const create = (entity, params) => {
  const bodyFormData = new FormData()
  const args = Object.keys(params)
  args.forEach((arg) => {
    bodyFormData.set(`data[attributes][${arg}]`, params[arg])
  })
  return axios.post(`${apiUrl}/api/v1/records?model=${entity}`, bodyFormData)
}
