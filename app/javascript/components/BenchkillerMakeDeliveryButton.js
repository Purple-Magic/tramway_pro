import React from 'react'
import _ from 'underscore'

const getIds = () => {
  if (_.isEmpty(window.localStorage.getItem('selectedOffers'))) {
    _.compact(window.localStorage.getItem('selectedOffers').split(','))
  } else {
    []
  }
}

class BenchkillerMakeDeliveryButton extends React.Component {
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
      <a className="btn btn-primary mb-4" href={this.pathWithIds()}>Сделать рассылку</a>
    )
  }
}

export default BenchkillerMakeDeliveryButton
