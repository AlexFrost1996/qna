class NotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    NotificationService.notify_question_subscribers(question)
  end
end
