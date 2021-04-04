import React from "react"
import PropTypes from "prop-types"

class Product extends React.Component {
  render () {
    const flexDirection = this.props.video.side == 'left' ? 'row' : 'row-reverse'
    const descriptionSide = this.props.video.side == 'left' ? 'right' : 'left'

    return (
      <div className="product" style={{ 'flex-direction': flexDirection }}>
        <div className={`description ${descriptionSide}`}>
          <h3>
            {this.props.description}
          </h3>
        </div>
        <div className={`video ${this.props.video.side}`}>
          <video poster={this.props.video.poster} src={this.props.video.src} autoPlay={ true } loop={ true } muted={ true }></video>
        </div>
      </div>
    );
  }
}

export default Product
