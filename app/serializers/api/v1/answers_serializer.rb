class Api::V1::AnswersSerializer < ActiveModel::Serializer
  attributes %i[id question_id body created_at updated_at best]
end
