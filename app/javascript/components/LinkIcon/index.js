import React from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import Icon from '../Icon'

const StyledIcon = styled(Icon)`
  cursor: pointer;
  &:hover {
    filter: brightness(80%);
  }
`

const LinkIcon = ({ href, name, type, ...props }) => {
  if (href) {
    return <StyledIcon { ...{ name, type, ...props } } onClick={() => { window.location.href = href }}/>
  }
  return <StyledIcon { ...{ name, type, ...props } } />
}

LinkIcon.propTypes = {
  href: PropTypes.string,
  name: PropTypes.string,
  type: PropTypes.string,
}

export default LinkIcon
