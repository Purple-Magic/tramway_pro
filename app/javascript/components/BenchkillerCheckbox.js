import React from 'react'
import _ from 'underscore'

const addToSelectedOffers = (uuid) => {
  if (_.isEmpty(window.localStorage.getItem('selectedOffers'))) {
    window.localStorage.setItem('selectedOffers', '')
  }
  let ids = window.localStorage.getItem('selectedOffers').split(',')
  ids.push(uuid)
  window.localStorage.setItem('selectedOffers', ids.join(','))
}

const removeFromSelectedOffers = (uuid) => {
  let ids = window.localStorage.getItem('selectedOffers').split(',')
  ids = _.reject(ids, (id => id === uuid))
  window.localStorage.setItem('selectedOffers', ids.join(','))
}

const checked = (uuid) => {
  if (window.localStorage.getItem('selectedOffers')) {
    let ids = window.localStorage.getItem('selectedOffers').split(',')
    return ids.includes(uuid)
  } else {
    return false
  }
}

class BenchkillerCheckbox extends React.Component {
  constructor(props) {
    super(props)

    this.change = this.change.bind(this)
  }

  change(e) {
    if (e.target.checked) {
      addToSelectedOffers(this.props.uuid)
    } else {
      removeFromSelectedOffers(this.props.uuid)
    }
  }

  render() {
    return (
      <input
        onChange={this.change}
        defaultChecked={checked(this.props.uuid)}
        type="checkbox"
        name={this.props.uuid}
        id={this.props.uuid}
      />
    )
  }
}

export default BenchkillerCheckbox
