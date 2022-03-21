class SubscribersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]

  def create
    authorize Subscriber

    @subscriber = current_user.subscribers.new(subscriber_params)
    @subscriber.save

    render partial: 'questions/subscribers'
  end

  def destroy
    find_subscriber
    authorize @subscriber
    @subscriber.destroy
    @subscriber = nil

    render partial: 'questions/subscribers'
  end

  private

  def subscriber_params
    params.permit(:question_id)
  end

  def find_subscriber
    @subscriber = Subscriber.find(params[:id])
    @question = @subscriber.question
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
