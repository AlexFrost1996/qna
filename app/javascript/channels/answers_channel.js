import consumer from "./consumer"
import Answer from "../components/answer"
import React from 'react'
import ReactDOM from 'react-dom'

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    this.perform("follow" , { question_id: gon.question_id })
  },

  disconnected() {
    console.log("disconected")
  },

  received(data) {
    console.log("received", data)
    if(gon.current_user == data.user.id) { return null }

    document.querySelector('.answers').append(document.createElement('div'))
    ReactDOM.render(
      <Answer data={data} />,
      document.querySelector('.answers').lastChild
    )
    let event = new Event('wsAnswer:added')
    document.dispatchEvent(event)
  }
});
