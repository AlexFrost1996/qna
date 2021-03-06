import React from 'react'
import axios from 'axios'
import { getMeta } from '../../utils/getMeta'
import Link from './components/link'
import File from './components/file'
import CommentForm from './components/commentForm'
import Votes from './components/votes'

class Answer extends React.Component {

  links = () => {
    const { links } = this.props.data
  
    const linkList = links.map((link) => {
      return(
        <Link
          key={link.id}
          id={link.id}
          name={link.name}
          url={link.url}
        />
      )
    })
    return linkList
  }

  renderLinks = () => {
    const { links } = this.props.data
    if (links.length == 0) { return null }

    return(
      <div>
        <p>Links:</p>
        {this.links()}
      </div>
    )
  }

  files = () => {
    const { files } = this.props.data
  
    const fileList = files.map((file) => {
      return(
        <File
          key={file.id}
          id={file.id}
          name={file.name}
          url={file.url}
          path={file.path}
        />
      )
    })
    return fileList
  }

  renderFiles = () => {
    const { files } = this.props.data
    if (files.length == 0) { return null }

    return(
      <div>
        {this.files()}
      </div>
    )
  }

  setTheBest = () => {
    const { id } = this.props.data
    const bestLink = `/answers/${id}/best`
    axios.defaults.headers['x-csrf-token'] = getMeta('csrf-token')
    axios.defaults.headers.patch['Accept'] = 'application/javascript'
    axios.patch(bestLink)
      .then((response) => {
        eval(response.data)
      }, (error) => {
        console.log(error);
      });
  }

  renderSetTheBest = () => {
    if (gon.question_owner != gon.current_user) { return null }
    const { id } = this.props.data

    return (
      <button 
        onClick={() => this.setTheBest()} 
        className='best-answer-link' 
        data-answer-id={id}
      >
        The Best Answer
      </button>
    )
  }

  renderNewComment = () => {
    const commentableType = 'answers'
    const { id } = this.props.data
    return (
      <CommentForm
        commentableId={id}
        commentableType={commentableType}
      />
    )
  }

  renderVotes = () => {
    const { id } = this.props.data
    return (
      <Votes votableId={id} />
    )
  }

  render() {
    const { body, id } = this.props.data
    return(
      <div className={`answer answer-id-${id}`}>
        <p>{body}</p>
        {this.renderLinks()}
        {this.renderFiles()}
        {this.renderSetTheBest()}
        {this.renderVotes()}
        {this.renderNewComment()}
        <div className="comments"/>
      </div>
    )
  }
}

export default Answer;
