class Api::V1::QuestionsSerializer < ActiveModel::Serializer
  attributes %i[id title body created_at updated_at short_title user_id]

  def short_title
    object.title.truncate(7)
  end
end
