import React from 'react'
import PropTypes from 'prop-types'
import { index } from '../packs/src/crud'
import { Row, Col, Form } from 'react-bootstrap'

const podcastOptions = (podcasts) => {
  return podcasts.map((podcast) => {
    return <option value={podcast.id} key={podcast.id}>{podcast.title}</option>
  })
}

class Highlight extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      highlights: [],
      episode: null,
      podcasts: [],
    }
    //setInterval(() => {
      index('Podcast::Highlight').then((response) => {
        this.setState({
          highlights: response.data.data,
        })
      })
      //}, 1000)
  }

  componentDidMount() {
    index('Podcast').then((response) => {
      this.setState({
        podcasts: response.data.data,
      })
    })
  }

  render () {
    if (this.state.episode) {
      return (
        <ul>
          {
            this.state.highlights.map((highlight) => {
              return (<li key={highlight.id}>
                {highlight.attributes.time}
              </li>)
            })
          }
        </ul>
      );
    } else {
      return (
        <Form>
          <Form.Group>
            <Form.Label>
              Выберите подкаст
            </Form.Label>
            <Form.Control as="select" onChange={(e) => { this.change('podcast_id', e.target.value) }}>
              { podcastOptions(this.state.podcasts) }
            </Form.Control>
          </Form.Group>
        </Form>
      )
    }
  }
}

Highlight.propTypes = {
  greeting: PropTypes.string
};
export default Highlight
