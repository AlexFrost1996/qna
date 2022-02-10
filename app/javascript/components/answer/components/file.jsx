import React from 'react'

class File extends React.Component {
  render() {
    const { id, name, url, path } = this.props

    return(
      <div id={`file-${id}`}>
        <div className="file">
          <a href={url}>{name}</a>
        </div>
      </div>
    )
  }
}

export default File;
