class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  def create
    authorize Comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      publish_comment
    else
      render json: @comment.errors.messages, status: :unprocessable_entity
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_commentable
    klass = [Answer, Question].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end

  def publish_comment
    question_id = @commentable.is_a?(Answer) ? @commentable.question.id : @commentable.id
    ActionCable.server.broadcast("comments_for_question_#{question_id}", CommentSerializer.new(@comment).as_json)
  end
end
