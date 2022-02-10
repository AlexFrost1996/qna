class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes %i[id question_id body created_at updated_at user_id best files]

  belongs_to :user
  has_many :links
  has_one :award

  def files
    object.files.map do |file|
      {
        id: file.id,
        name: file.filename.to_s,
        url: rails_blob_path(file, only_path: true),
        path: file_path(file)
      }
    end
  end
end
