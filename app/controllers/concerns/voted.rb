module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, :find_vote, only: %i[like dislike]
  end

  def like
    click_processing(:like)
  end

  def dislike
    click_processing(:dislike)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params['id'])
    authorize @votable, :vote?, policy_class: VotePolicy
  end

  def find_vote
    @vote = @votable.votes.find_by(user: current_user)
  end

  def click_processing(action)
    if !@vote.present?
      create_vote(action)
    elsif @vote.send("#{action}?")
      authorize_cancel_vote
      @vote.click = nil
      @vote.destroy
      render_votable
    else
      authorize_cancel_vote
      @vote.destroy
      create_vote(action)
    end
  end

  def create_vote(action)
    @vote = @votable.votes.new(user: current_user, click: action)
    if @vote.save
      render_votable
    else
      render json: @vote.errors.messages, status: :unprocessable_entity
    end
  end

  def authorize_cancel_vote
    authorize @vote, :cancel_vote?, policy_class: VotePolicy
  end

  def render_votable
    render json: {
      votable_id: @votable.id,
      rating: @votable.rating,
      model: @vote.votable_type.underscore,
      user_vote: @vote.click
    }
  end
end
