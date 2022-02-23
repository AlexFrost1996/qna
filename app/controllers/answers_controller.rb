class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy best]
  after_action :publish_answer, only: %i[create]

  def create
    authorize Answer
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    authorize @answer
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    authorize @answer
    @answer.destroy
  end

  def best
    @question = @answer.question
    authorize @question
    @answer.set_the_best
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                    links_attributes: [:name, :url],
                                    award_attributes: [:title, :image])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("answers_for_question_#{@question.id}", AnswerSerializer.new(@answer).as_json)
  end
end
