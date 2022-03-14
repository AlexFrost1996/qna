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

  def create
    @current_user = User.find_by(id: question_params['user_id'])
    authorize Question
    @question = Question.new(question_params)

    if @question.save
      head :ok
    else
      render json: @question.errors.messages
    end
  end

  def update
    @current_user = User.find_by(id: question_params['user_id'])
    authorize @question
    if @question.update(question_params)
      head :ok
    else
      render json: @question.errors.messages
    end
  end

  def destroy
    @current_user = User.find_by(id: question_params['user_id'])
    authorize @question
    if @question.destroy
      head :ok
    else
      render json: @question.errors.messages
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, links_attributes: %i[name url])
  end
end
