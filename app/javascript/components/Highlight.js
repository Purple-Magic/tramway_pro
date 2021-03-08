import React from 'react'
import PropTypes from 'prop-types'
import { index, show, create } from '../packs/src/crud'
import { Button, Form, ListGroup } from 'react-bootstrap'
import _ from 'underscore'

const podcastOptions = (podcasts) => {
  return podcasts.map((podcast) => {
    return <option value={podcast.id} key={podcast.id}>{podcast.attributes.title}</option>
  })
}

const highlightsList = (highlights) => {
  return highlights.map((highlight) => {
    return (
      <ListGroup.Item key={highlight.id}>
        {highlight.attributes.time}
      </ListGroup.Item>
    )
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

    this.createEpisode = this.createEpisode.bind(this)

    setInterval(() => {
      if (this.state.episode) {
        show('Podcast::Episode', this.state.episode.data.id).then((response) => {
          const included = response.data.included
          if (included) {
            this.setState({
              highlights: included.filter(item => item.type == 'podcast-highlights')
            })
          }
        })
      }
    }, 1000)
  }

  componentDidMount() {
    index('Podcast').then((response) => {
      this.setState({
        podcasts: response.data.data,
        params: {
          podcast_id: _.first(response.data.data).id
        }
      })
    })
  }

  componentDidUpdate() {
    if (this.state.episode) {
      document.getElementById('episodeId').value = this.state.episode.data.id
    }
  }

  change(attribute, value) {
    this.setState({
      params: {
        ...this.state.params,
        [attribute]: value
      }
    })
  }

  createEpisode() {
    create('Podcast::Episode', this.state.params).then((response) => {
      this.setState({
        episode: response.data,
      })
    })
  }

  render () {
    if (this.state.episode) {
      return (
        <>
          <h2>
            { _.first(this.state.episode.included.filter(item => item.type == 'podcasts')).attributes.title }. Выпуск №{ this.state.episode.data.attributes.number }
          </h2>
          <ListGroup>
            { highlightsList(this.state.highlights) }
          </ListGroup>
        </>
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
          <Button onClick={this.createEpisode}>Создать</Button>
        </Form>
      )
    }
  }
}

Highlight.propTypes = {
  greeting: PropTypes.string
};
export default Highlight
