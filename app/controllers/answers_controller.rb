class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:edit, :update, :destroy, :mark_the_best]
  after_action :publish_answer, only: [:create]



  respond_to :html, :js

  load_and_authorize_resource

  def edit
    unless current_user.author_of?(@answer)
      redirect_to question_path(@answer.question)
    end
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    respond_with(@answer)
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      @answer.errors[:base] << 'You can update only your own answer'
    end
    respond_with(@answer)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      @answer.errors[:base] << 'You can remove only your own answer'
    end
    respond_with(@answer)
  end

  def mark_the_best
    authorize! :mark_the_best, @answer # Стоит только удалить эту строку - авторизация не работает. Проверено много раз.
    @answer.mark_the_best
    @all_answers = Answer.ordered_answers(@answer.question)
    respond_with(@answer)
  end

  private

  def set_answer
    @answer = params[:id].present? ? Answer.find(params[:id]) : Answer.find(params[:answer_id])

  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def send_answer_notifications
    AnswerMailer.send_notifications(@answer)
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "question_#{@answer.question_id}",
        {
            obj: 'answer',
            answer: @answer,
            answer_score: @answer.score,
            author: @answer.user.name,
            id: @answer.id,
            attachments: @answer.attachments.map { |a| a.file.identifier unless a.new_record? }.join('; '),
            author_id: @answer.user_id,
            vp_url: answer_votes_path(@answer, vote: 'plus', votable_class: 'Answer'),
            vm_url: answer_votes_path(@answer, vote: 'minus', votable_class: 'Answer'),
            vc_url: answer_votes_path(@answer, 0, votable_class: 'Answer'),
            comments: @answer.comments.pluck(:body)
        }
    )

  end

end
