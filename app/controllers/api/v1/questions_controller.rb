class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: Api::V1::QuestionsSerializer
  end

  def show
    render json: @question, serializer: Api::V1::QuestionSerializer
  end

  def answers
    @question = Question.find(params['question_id'])
    @answers = @question.answers
    render json: @answers, each_serializer: Api::V1::AnswersSerializer
  end

  private

  def load_question
    @question = Question.find(params['id'])
  end
end
