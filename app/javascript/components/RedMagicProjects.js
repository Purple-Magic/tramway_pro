import React from 'react'
import { snakeCase } from "snake-case"
import LinkIcon from './LinkIcon'
import styled from 'styled-components'
import Iframe from 'react-iframe'

const CloseButton = styled(LinkIcon)`
  color: white;
  position: fixed;
  top: 2rem;
  right: 2rem;
  font-size: 3rem;
`

class Projects extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      showStates: {
        it_way: 'hidden',
        red_magic_live: 'hidden',
        who_knew: 'hidden',
        red_magic_tv: 'hidden',
      },
    }

    this.show = this.show.bind(this)
  }

  show(project) {
    this.setState({ showStates: { [project]: 'active' } })
  }

  hide(project)  {
    this.setState({ showStates: { [project]: 'hidden' } })
  }

  render() {
    return (
      <>
        <div className="row-projects">
          {
            [ 'Red Magic Live', 'Who knew' ].map((project) => {
              const snakeCaseName = snakeCase(project)
              return (
                <div className={`project ${snakeCaseName}`} onClick={() => { this.show(snakeCaseName) }}>
                  <div className={`cover ${snakeCaseName}`}>
                    {project}
                  </div>
                </div>
              )
            })
          }
        </div>
        <div className="row-projects">
          {
            [ 'IT Way', 'Red Magic TV' ].map((project) => {
              const snakeCaseName = snakeCase(project)
              return (
                <div className={`project ${snakeCaseName}`} onClick={() => { this.show(snakeCaseName) }}>
                  <div className={`cover ${snakeCaseName}`}>
                    {project}
                  </div>
                </div>
              )
            })
          }
        </div>
        <div className={`project-page it_way_page ${this.state.showStates.it_way}`}>
          <CloseButton name="window-close" type="solid" onClick={() => { this.hide('it_way') }} />
          <div className="red_magic_live">
            <h1>
              Red Magic Live
            </h1>
          </div>
          <div className="it_way">
            <h1>
              IT Way
            </h1>
            <h2>
              ИТ-сообщество
            </h2>
            <div className="stats mt-4">
              <div className="stat">
                <h2>
                  100+
                </h2>
                <span>
                  видео-роликов за 2 года
                </span>
              </div>
              <div className="stat">
                <h2>
                  ≈50
                </h2>
                <span>
                  часов контента
                </span>
              </div>
              <div className="stat">
                <h2>
                  1
                </h2>
                <span>
                  lofi hip-hop like стрим
                </span>
              </div>
            </div>
            <div className="product">
              <div className="description right">
                <h3>
                  Отчётные видео с конференций и форумов. Это поставленные видео, где коротко, а самое главное, интересно рассказывается о крупных мероприятиях.
                </h3>
              </div>
              <div className="video left">
                <video poster='/system/red_magic/video_poster.png' src="/system/red_magic/center.mp4" autoPlay={ true } loop={ true } muted={ true }></video>
              </div>
            </div>
            <div className="product">
              <div className="video right">
                <video poster='/system/red_magic/video_poster.png' src="/system/red_magic/center.mp4" autoPlay={ true } loop={ true } muted={ true }></video>
              </div>
              <div className="description left">
                <h3>
                  Видео выступлений на конференциях
                </h3>
              </div>
            </div>
          </div>
          <div className="red_magic_tv">
            <h1>
              Red Magic TV
            </h1>
          </div>
          <div className="who_knew">
            <h1>
              Хунью
            </h1>
          </div>
        </div>
      </>
    )
  }
}

export default Projects
