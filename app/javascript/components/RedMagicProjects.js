import React from 'react'
import { snakeCase } from "snake-case"

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
            <div>
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
