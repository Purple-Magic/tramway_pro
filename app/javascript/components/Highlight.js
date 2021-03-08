import React from 'react'
import PropTypes from 'prop-types'
import { index } from '../packs/src/crud'

class Highlight extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      highlights: [],
    }
    //setInterval(() => {
      index('Podcast::Highlight').then((collection) => {
        this.setState({
          highlights: collection,
        })
      })
      //}, 1000)
  }

  render () {
    return (
      <React.Fragment>
        <ul>
          {
            highlights.map((highlight) => {
              <li>
                {highlight.time}
              </li>
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
