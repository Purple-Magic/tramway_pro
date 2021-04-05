import React from "react"
import PropTypes from "prop-types"
import LinkIcon from '../LinkIcon'

class Toggle extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      showState: 'hidden'
    }

    this.toggle = this.toggle.bind(this)
  }

  toggle() {
    this.setState({
      showState: this.state.showState === 'hidden' ? 'show' : 'hidden',
    })
  }

  render () {
    return (
      <div className={`toggle-button ${this.state.showState}`}>
        <LinkIcon name={this.state.showState === 'hidden' ? 'bars' : 'times' } type="solid" onClick={() => { this.toggle() } } />
      </div>
    );
  }
}

export default Toggle
