class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  # before_action :set_question, only: [:show, :edit, :destroy, :update]
  after_action :publish_question, only: [:create]

  respond_to :html, :js

  load_and_authorize_resource


  def index
    respond_with(@questions = Question.all)
  end

  def show
    authorize! :read, @question
    respond_with(@question)
  end

  def new
    authorize! :create, @question
    respond_with(@question = Question.new)
  end

   def edit
   end

  def create
    respond_with (@question = current_user.questions.create(question_params))
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      @question.errors[:base] << 'The only author of the question can edit it'
    end
    respond_with(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    else
      @question.errors[:base] << 'You can remove only your own question'
    end
    respond_with(@question)
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
        'questions',
        { obj: 'question',
          action: 'create',
          question: @question,
          attachments: @question.attachments.map { |a| a.file.identifier }.join('; '),
          question_score: @question.score,
          question_url: question_path(@question),
          author_id: @question.user_id,
          author: @question.user.name,
          id: @question.id,
          vp_url: question_votes_path(@question, vote: 'plus', votable_class: 'Question'),
          vm_url: question_votes_path(@question, vote: 'minus', votable_class: 'Question'),
          vc_url: question_vote_path(@question, 0, votable_class: 'Question'),
          comments: @question.comments.pluck(:body)
        }
    )
  end

  def set_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
