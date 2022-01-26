import React from 'react'
import _ from 'underscore'

const getIds = () => {
  if (_.isEmpty(window.localStorage.getItem('selectedOffers'))) {
    return []
  } else {
    return _.compact(window.localStorage.getItem('selectedOffers').split(','))
  }
}

class BenchkillerDeliveryButton extends React.Component {
  constructor(props) {
    super(props)

    this.pathWithIds = this.pathWithIds.bind(this)
    this.state = {
      ids: getIds()
    }
  }

  componentDidMount() {
    setInterval(() => {
      this.setState({
        ids: getIds()
      })
    }, 200)
  }
  
  pathWithIds() {
    if (_.any(this.state.ids)) {
      return this.props.path + `?keys=${this.state.ids.join(',')}`
    } else {
      return this.props.path
    }
  }

  render() {
    return (
      <>
        {
          _.any(getIds()) ? <a className="btn btn-warning mb-4" style={{ 'margin-right': '1rem' }} onClick={() => window.localStorage.removeItem('selectedOffers')} href='#'>Убрать выделение</a> : <></>
        }
        <a className="btn btn-primary mb-4" onClick={() => window.localStorage.removeItem('selectedOffers')} href={this.pathWithIds()}>Сделать рассылку</a>
      </>
    )
  }
}

export default BenchkillerDeliveryButton
