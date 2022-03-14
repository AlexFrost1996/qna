class Api::V1::QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes %i[id title body created_at updated_at files]
  has_many :comments
  has_many :links

  def files
    arr = []
    object.files.each do |file|
      arr << rails_blob_path(file, only_path: true)
    end
    arr
  end
end
