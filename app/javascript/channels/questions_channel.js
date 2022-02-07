import consumer from "./consumer"
import Question from "../components/question"
import React from 'react'
import ReactDOM from 'react-dom'

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    this.perform("follow")
  },

  disconnected() {
    console.log("disconected")
  },

  received(data) {
    const questions = document.querySelector('.questions')

    if (!questions) { return null }

    questions.append(document.createElement('p'))

    ReactDOM.render(
      <Question data={data} />,
      document.querySelector('.questions p:last-child')
    )
  }
});
