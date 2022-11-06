import React from 'react'
import { Table } from 'react-bootstrap'
import _ from 'underscore'
import styled from 'styled-components'

const StatTable = styled.div`
  display: flex;
  flex-direction: column;

  @keyframes slideInFromLeft {
    0% {
      opacity: 0;
      transform: translateY(-20px);
    }
    100% {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .karmaTable {
    animation: 0.5s ease-out 0s 1 slideInFromLeft;
  }
`

class ItWayPersonStatTable extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      karmaTableShowState: 'hidden',
    }

    this.toggleKarmaTable = this.toggleKarmaTable.bind(this)
    this.karmaTable = this.karmaTable.bind(this)
  }

  toggleKarmaTable() {
    if (this.state.karmaTableShowState == 'visible') {
      this.setState({ karmaTableShowState: 'hidden' })
    } else {
      this.setState({ karmaTableShowState: 'visible' })
    }
  }

  karmaTable() {
    if (this.state.karmaTableShowState == 'visible') {
      return(
        <div className="karmaTable">
          <Table>
            <tbody>
              {
                this.props.karma.data.map((row, index) => {
                  return (
                    <tr key={index}>
                      <td colspan="2" style={{ width: '100px' }}>
                        { row.title }
                      </td>
                      <td>
                        { row.role }
                      </td>
                      <td>
                        { row.points }
                      </td>
                    </tr>
                  )
                })
              }
            </tbody>
          </Table>
        </div>
      )
    }

    return <></>
  }

  render() {
    return (
      <StatTable>
        <div>
          <a onClick={this.toggleKarmaTable}>
            <h3>
              { this.props.karma.points }
            </h3>
          </a>
        </div>
        { this.karmaTable() }
      </StatTable>
    )
  }
}

export default ItWayPersonStatTable
