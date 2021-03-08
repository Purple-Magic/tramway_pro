import React from 'react'
import PropTypes from 'prop-types'
import { index, create } from '../packs/src/crud'
import { Button, Form } from 'react-bootstrap'

const podcastOptions = (podcasts) => {
  return podcasts.map((podcast) => {
    return <option value={podcast.id} key={podcast.id}>{podcast.attributes.title}</option>
  })
}

class Highlight extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      highlights: [],
      episode: null,
      podcasts: [],
      params: {},
    }
    setInterval(() => {
      if (this.state.episode) {
        index('Podcast::Highlight').then((response) => {
          this.setState({
            highlights: response.data.data,
          })
        })
      }
    }, 1000)
  }

  componentDidMount() {
    index('Podcast').then((response) => {
      this.setState({
        podcasts: response.data.data,
      })
    })
  }

  change(attribute, value) {
    this.setState({
      params: {
        ...this.state.params,
        [attribute]: value
      }
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
          <Form.Group>
            <Form.Label>
              Введите номер эпизода
            </Form.Label>
            <Form.Control type="text" onChange={(e) => { this.change('number', e.target.value) }}/>
          </Form.Group>
          <Button onClick={() => { create('Podcast::Episode', this.state.params) } }>Создать</Button>
        </Form>
      )
    }
  }
}

Highlight.propTypes = {
  greeting: PropTypes.string
};
export default Highlight
