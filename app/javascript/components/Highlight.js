import React from 'react'
import PropTypes from 'prop-types'
import { index, show, create } from '../packs/src/crud'
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

    this.createEpisode = this.createEpisode.bind(this)

    setInterval(() => {
      if (this.state.episode) {
        show('Podcast::Episode', this.state.episode.id).then((response) => {
          this.setState({
            highlights: response.data.included.filter(item => item.type == 'podcast-highlights')
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

  componentDidUpdate() {
    if (this.state.episode) {
      document.getElementById('episodeId').value = this.state.episode.id
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
        episode: response.data.data,
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
