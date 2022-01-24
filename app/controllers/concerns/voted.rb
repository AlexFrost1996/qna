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
  end

  def find_vote
    @vote = @votable.votes.find_by(user: current_user)
  end

  def click_processing(click)
    if !@vote.present?
      create_vote(click)
    elsif @vote.send("#{click}?")
      @vote.click = nil
      @vote.destroy
      render_votable
    else
      @vote.destroy
      create_vote(click)
    end
  end

  def create_vote(click)
    @vote = @votable.votes.new(user: current_user, click: click)
    if @vote.save
      render_votable
    else
      render json: @vote.errors.messages, status: :unprocessable_entity
    end
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
