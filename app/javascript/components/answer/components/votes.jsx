import React from 'react'

class Votes extends React.Component {

  renderLike = () => {
    const { votableId } = this.props
    return (
      <div className="like">
        <a className="vote vote-up" data-remote="true" rel="nofollow" data-method="post" href={`/answers/${votableId}/like`}>
          <span>like</span>
          <i className="fa fa-lg fa-thumbs-o-up"></i>
        </a>
      </div>
    )
  }

  renderDislike = () => {
    const { votableId } = this.props
    return (
      <div className="dislike">
        <a className="vote vote-down" data-remote="true" rel="nofollow" data-method="post" href={`/answers/${votableId}/dislike`}>
          <span>dislike</span>
          <i className="fa fa-lg fa-thumbs-o-down"></i>
        </a>
      </div>
    )
  }

  renderLikeWithoutAction = () => {
    return (
      <div className="like">
        <a className="vote vote-up">
          <span>like</span>
          <i className="fa fa-lg fa-thumbs-o-up"></i>
        </a>
      </div>
    )
  }

  renderDislikeWithoutAction = () => {
    return (
      <div className="dislike">
        <a className="vote vote-down">
          <span>dislike</span>
          <i className="fa fa-lg fa-thumbs-o-down"></i>
        </a>
      </div>
    )
  }

  renderRating = () => {
    return (
      <div className="rating">0</div>
    )
  }

  render() {
    return(
      <div className="votes">
        <div className="wrapper">
          {gon.current_user ? this.renderLike() : this.renderLikeWithoutAction()}
          {this.renderRating()}
          {gon.current_user ? this.renderDislike() : this.renderDislikeWithoutAction()}
        </div>
      </div>
    )
  }
}

export default Votes;
