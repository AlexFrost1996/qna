import React from 'react'

class Question extends React.Component {
  render() {
    const { link, title } = this.props.data
    return( 
      <a href={link}>{title}</a>
    );
  }
}

export default Question;
