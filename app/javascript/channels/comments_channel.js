import consumer from "./consumer"
import React from 'react'
import ReactDOM from 'react-dom'
import Comment from "../components/comment"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    this.perform("follow" , { question_id: gon.question_id })
  },

  disconnected() {
    console.log("disconected")
  },

  received(data) {
    const commentableType = data.commentable_type
    const commentableId = data.commentable_id

    if (commentableType == 'answer') {
      const answer = document.querySelector(`.answer.answer-id-${commentableId}`)
      const comments = answer.querySelector('.comments')
      comments.append(document.createElement('div'))
      renderComment (data, comments.lastChild)
    } else {
      const question = document.querySelector(`.question.question-id-${commentableId}`)
      const comments = question.querySelector('.comments')
      comments.append(document.createElement('div'))
      renderComment (data, comments.lastChild)
    }

  }
});

function renderComment (data, domElement) {
  ReactDOM.render(
    <Comment data={data} />,
    domElement
  )
}
