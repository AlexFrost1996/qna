class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes %i[id title body created_at updated_at link]

  belongs_to :user

  def link
    question_path(object)
  end
end
