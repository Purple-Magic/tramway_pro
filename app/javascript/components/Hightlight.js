import React from "react"
import PropTypes from "prop-types"
class Hightlight extends React.Component {
  render () {
    return (
      <React.Fragment>
        Greeting: {this.props.greeting}
      </React.Fragment>
    );
  }
}

Hightlight.propTypes = {
  greeting: PropTypes.string
};
export default Hightlight
