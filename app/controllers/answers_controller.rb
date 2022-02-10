class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy best]
  after_action :publish_answer, only: %i[create]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @question = @answer.question
    if current_user&.author_of?(@answer)
      @answer.update(answer_params)
    else
      redirect_to question_path(@answer.question), notice: 'You are not permitted.'
    end
  end

  def destroy
    if current_user&.author_of?(@answer)
      @answer.destroy
    else
      redirect_to question_path(@answer.question), notice: 'You cannot delete the wrong answer.'
    end
  end

  def best
    @question = @answer.question
    @answer.set_the_best if current_user.author_of?(@question)
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
