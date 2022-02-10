import React from 'react'

class Comment extends React.Component {
  render() {
    const { id, text, created_at, user} = this.props.data
    return( 
      <div className={`comment comment-id-${id}`}>
        <div className="head">
          <div className="email">
           {user.email}
          </div>
          <div className="date">
           {created_at}
          </div>
        </div>
        <div className="text">
          {text}
        </div>
      </div>
    );
  }
}

export default Comment;
