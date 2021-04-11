import React from 'react'
import { snakeCase } from "snake-case"
import LinkIcon from '../LinkIcon'
import styled from 'styled-components'
import Iframe from 'react-iframe'
import Product from './Product'

const CloseButton = styled(LinkIcon)`
  color: white;
  position: fixed;
  top: 2rem;
  right: 2rem;
  font-size: 3rem;
`

const Project = (project, component) => {
  const snakeCaseName = snakeCase(project)
  const image = `url(/system/red_magic/projects/${snakeCaseName}-${component.state.hoverStates[snakeCaseName] ? 'cover.gif' : 'first-frame.jpg'})`
  return (
    <div className={`project ${snakeCaseName}`} onClick={() => { component.show(snakeCaseName) }}>
      <div
        className={`cover ${snakeCaseName}`}
        onMouseEnter={() => component.hover(snakeCaseName)}
        onMouseLeave={() => component.unHover(snakeCaseName)}
        style={{ 'background-image': image }}
      >
        <div>
          {project}
          <button className="more-info" onClick={() => component.show(snakeCaseName)}>Подробнее</button>
        </div>
      </div>
    </div>
  )
}

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
      hoverStates: {
        it_way: false,
        red_magic_live: false,
        who_knew: false,
        red_magic_tv: false,
      },
    }

    this.show = this.show.bind(this)
    this.hover = this.hover.bind(this)
    this.unHover = this.unHover.bind(this)
  }

  show(project) {
    this.setState({ showStates: { [project]: 'active' } })
  }

  hide(project)  {
    this.setState({ showStates: { [project]: 'hidden' } })
  }

  hover(project) {
    this.setState({ hoverStates: { [project]: true } })
  }

  unHover(project) {
    this.setState({ hoverStates: { [project]: false } })
  }

  render() {
    return (
      <>
        <div className="row-projects">
          {
            [ 'Red Magic Live', 'Who knew' ].map((name) => Project(name, this))
          }
        </div>
        <div className="row-projects">
          {
            [ 'IT Way', 'Red Magic TV' ].map((name) => Project(name, this))
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
            <Product video={{ side: 'left', src: "/system/red_magic/center.mp4", poster: '/system/red_magic/video_poster.png' }} description="Отчётные видео с конференций и форумов. Это поставленные видео, где коротко, а самое главное, интересно рассказывается о крупных мероприятиях." logo={this.props.logo} />
            <Product video={{ side: 'right', src: "/system/red_magic/center.mp4", poster: '/system/red_magic/video_poster.png' }} description="Видео выступлений на конференциях" logo={this.props.logo}/>
            <Product video={{ side: 'left', src: "/system/red_magic/center.mp4", poster: '/system/red_magic/video_poster.png' }} description="Трёхдневный онлайн фестиваль! 26 часов образовательного и развлекательного канала из трёх локаций в два канала." logo={this.props.logo} />
            <Product video={{ side: 'right', src: "/system/red_magic/center.mp4", poster: '/system/red_magic/video_poster.png' }} description="Бесконечный анимационный cтрим для работы в стиле популярного lofi girl. Автор анимации noTea (тут должна быть ссылка)" logo={this.props.logo} />
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
