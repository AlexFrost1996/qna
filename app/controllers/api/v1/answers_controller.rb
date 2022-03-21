class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy]
  
  def show
    @answer = Answer.find(params['id'])
    render json: @answer, serializer: Api::V1::AnswerSerializer
  end

  def create
    @current_user = User.find_by(id: answer_params['user_id'])
    authorize Answer
    if @question.answers.create(answer_params)
      head :ok
    else
      render json: @answer.errors.messages
    end
  end

  def update
    @current_user = User.find_by(id: answer_params['user_id'])
    authorize @answer
    if @answer.update(answer_params)
      head :ok
    else
      render json: @answer.errors.messages
    end
  end

  def destroy
    @current_user = User.find_by(id: answer_params['user_id'])
    authorize @answer
    if @answer.destroy
      head :ok
    else
      render json: @answer.errors.messages
    end
  end

  private

  def find_question
    @question = Question.find(answer_params['question_id'])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id, files: [], links_attributes: %i[name url])
  end
end
