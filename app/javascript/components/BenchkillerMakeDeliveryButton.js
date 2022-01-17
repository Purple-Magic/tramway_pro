import React from 'react'
import _ from 'underscore'

class BenchkillerMakeDeliveryButton extends React.Component {
  constructor(props) {
    super(props)

    this.pathWithIds = this.pathWithIds.bind(this)
    this.state = {
      ids: _.compact(window.localStorage.getItem('selectedOffers').split(','))
    }
  }

  componentDidMount() {
    setInterval(() => {
      this.setState({
        ids: _.compact(window.localStorage.getItem('selectedOffers').split(','))
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
