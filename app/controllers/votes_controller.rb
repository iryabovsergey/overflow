class VotesController < ApplicationController
  before_action :authenticate_user!

  before_action :get_votable_object_class
  before_action :find_vote, only: [:destroy]

  load_and_authorize_resource :find_by => :params, only: :create

  def create
    if @vote.save
      render json: { score: @votable_obj.score }
    else
      render json: { errors: @vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @vote
    if @vote.present? && @vote.destroy
      render json: { score: @votable_obj.score }
    else
      render json: { errors: (@vote) ? @vote.errors.full_messages : ['You did not vote for this record yet'] }, status: :unprocessable_entity
    end
  end

  private

  def find_vote
    @vote = @votable_obj.votes.find_by(user: current_user)
  end

  def get_votable_object_class
    klass_name = params[:votable_class]
    @votable_obj = (Object.const_get klass_name).find(params["#{klass_name.downcase}_id"])
    @vote = (action_name=="destroy") ? @votable_obj.votes.find_by(user: current_user) : @votable_obj.votes.build(user: current_user, vote: params[:vote]=="plus" ? 1 : -1)
  end

end