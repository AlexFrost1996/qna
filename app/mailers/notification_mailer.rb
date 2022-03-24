class NotificationMailer < ApplicationMailer
  def notify_question_subscriber(user, question)
    @question = question

    mail to: user.email, subject: 'Get read new answer for your question!'
  end
end
