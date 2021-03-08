import React from 'react'
import PropTypes from 'prop-types'
import { index } from '../packs/src/crud'

class Highlight extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      highlights: [],
    }
    setInterval(() => {
      index('Podcast::Highlight').then((response) => {
        this.setState({
          highlights: response.data.data,
        })
      })
    }, 1000)
  }

  render () {
    return (
      <React.Fragment>
        <ul>
          {
            this.state.highlights.map((highlight) => {
              return (<li key={highlight.id}>
                {highlight.attributes.time}
              </li>)
            })
          }
        </ul>
      </React.Fragment>
    );
  }
}

Highlight.propTypes = {
  greeting: PropTypes.string
};
export default Highlight
