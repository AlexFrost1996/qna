class CommentSerializer < ActiveModel::Serializer
  attributes %i[id text created_at updated_at commentable_type commentable_id]

  belongs_to :user

  def commentable_type
    object.commentable_type.underscore
  end
end
