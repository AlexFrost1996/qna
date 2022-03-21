class QuestionsController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]
  after_action :publish_question, only: %i[create]

  def index
    authorize Question
    @questions = Question.all
  end

  def show
    authorize Question
    @answer = Answer.new
    @answers = @question.answers
    @answer.links.new
    @subscriber = Subscriber.find_by(user_id: current_user, question_id: @question)

    gon.push(
      current_user: current_user&.id,
      question_owner: @question.user.id,
      question_id: @question.id
    )
  end

  def new
    authorize Question
    @question = Question.new
    @question.links.new
    @award = Award.new(question: @question)
  end

  def create
    authorize Question
    @question = Question.new(question_params)
    @question.user = current_user

    return unless @question.save
    redirect_to @question, notice: 'Your question successfully created.'
    @subscriber = current_user.subscribers.create(question_id: @question.id)
  end

  def update
    authorize @question
    @question.update(question_params)
  end

  def destroy
    authorize @question
    @question.destroy
    redirect_to root_path, notice: 'Your question successfully deleted.'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                      links_attributes: [:name, :url],
                                      award_attributes: [:title, :image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', QuestionSerializer.new(@question).as_json)
  end
end
