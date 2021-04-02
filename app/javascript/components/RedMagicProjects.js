import React from 'react'

class Projects extends React.Component {
  render() {
    return (
      <>
      <div className="row-projects">
      <div className="project red_magic_live">
      <div className="cover red_magic_live">
      Red Magic Live
      </div>
      </div>
      <div className="project who_knew">
      <div className="cover who_knew">
      Хунью
      </div>
      </div>
      </div>
      <div className="row-projects">
      <div className="project it_way">
      <div className="cover it_way">
      IT Way
      </div>
      </div>
      <div className="project red_magic_tv">
      <div className="cover red_magic_tv">
      Red Magic TV
      </div>
      </div>
      </div>
        <div className="project-page active it_way_page">
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
