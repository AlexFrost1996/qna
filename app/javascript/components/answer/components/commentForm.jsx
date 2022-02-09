import React from 'react'
import axios from 'axios'
import { getMeta } from '../../../utils/getMeta'

class commentForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = {value: ''}

    this.handleChange = this.handleChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  handleSubmit(event) {
    event.preventDefault()
    this.sendComment()
  }

  handleChange(event) {
    this.setState({value: event.target.value})
  }

  sendComment = () => {
    const { commentableId, commentableType } = this.props
    const newCommentPath = `/${commentableType}/${commentableId}/comments`
    axios.defaults.headers['x-csrf-token'] = getMeta('csrf-token')
    axios.defaults.headers.patch['Accept'] = 'application/javascript'
    const data = {
      text: this.state.value
    }
    axios.post(newCommentPath, data)
      .then((response) => {
      }, (error) => {
        console.log(error);
      });
  }

  render() {
    if (!gon.current_user) { return null }

    return (
      <div className="new-comment">
        <form onSubmit={this.handleSubmit}>
          <label>
            Comment
            <textarea
              value={this.state.value} 
              onChange={this.handleChange}
            />
          </label>
          <input type="submit" value="Send" />
        </form>
      </div>
    );
  }
}

export default commentForm;
