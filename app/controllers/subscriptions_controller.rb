class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_question, only: :create
  before_action :set_subscription, only: :destroy

  load_and_authorize_resource

  def create
    s = @question.subscriptions.new(user_id: current_user.id)
    if s.save
      redirect_to @question, notice: 'You have subscribed successfully'
    else
      redirect_to @question, errors: s.errors.full_messages
    end
  end

  def destroy
    @subsription.destroy
    redirect_to @subsription.question, notice: 'You have unsubscribed successfully'
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subsription = Subscription.find(params[:id])
  end

end
