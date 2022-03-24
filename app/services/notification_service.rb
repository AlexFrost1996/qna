class NotificationService
  def self.notify_question_subscribers(question)
    User.joins(:subscribers).where(subscribers: { question: question }).find_each do |user|
      NotificationMailer.notify_question_subscriber(user, question)
    end
  end
end
