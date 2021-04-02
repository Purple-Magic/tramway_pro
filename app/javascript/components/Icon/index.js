import React from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import * as solid from '@fortawesome/free-solid-svg-icons'
import * as regular from '@fortawesome/free-regular-svg-icons'
import _ from 'lodash'

const ProperSizedIcon = styled(FontAwesomeIcon)`
  margin-right: 0.5rem
`

const Icon = ({ name, type, ...props }) => {
  let iconModule = null
  switch(type) {
    case 'regular':
      iconModule = regular
      break
    case 'solid':
      iconModule = solid
      break
  }
  return <ProperSizedIcon icon={iconModule[`fa${_.upperFirst(_.camelCase(name))}`]} {...props} />
}

Icon.propTypes = {
  name: PropTypes.string,
  type: PropTypes.string,
}

export default Icon
