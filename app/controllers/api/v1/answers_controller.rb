class Api::V1::AnswersController < Api::V1::BaseController
  def show
    @answer = Answer.find(params['id'])
    render json: @answer, serializer: Api::V1::AnswerSerializer
  end
end
