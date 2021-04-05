import React from "react"
import PropTypes from "prop-types"
import LinkIcon from '../LinkIcon'

class Navbar extends React.Component {
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
      <>
        <nav className={this.state.showState}>
          <ul>
            {
              this.props.links.map((link) => {
                return (
                  <li>
                    <a href={link.url}>{link.text}</a>
                  </li>
                )
              })
            }
          </ul>
        </nav>
        <div className={`toggle-button ${this.state.showState}`}>
          <LinkIcon name={this.state.showState === 'hidden' ? 'bars' : 'times' } type="solid" onClick={() => { this.toggle() } } />
        </div>
      </>
    );
  }
}

export default Navbar
