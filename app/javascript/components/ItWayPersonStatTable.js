import React from 'react'
import { Table } from 'react-bootstrap'
import _ from 'underscore'
import styled from 'styled-components'

const StatTable = styled.div`
  display: flex;
  flex-direction: column;
`

class ItWayPersonStatTable extends React.Component {
  constructor(props) {
    super(props)
    console.log(props.karma)

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
        <div>
        <Table>
          <tbody>
            {
              this.props.karma.data.map((row, index) => {
                return (
                  <tr key={index}>
                    <td>
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
