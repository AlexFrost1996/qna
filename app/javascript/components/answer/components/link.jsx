import React from 'react'

class Link extends React.Component {
  render() {
    const { id, name, url } = this.props

    return(
      <div id={`link-${id}`}>
        <div className="link">
          <a href={url}>{name}</a>
        </div>
      </div>
    )
  }
}

export default Link;
