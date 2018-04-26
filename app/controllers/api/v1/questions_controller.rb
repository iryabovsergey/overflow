class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end