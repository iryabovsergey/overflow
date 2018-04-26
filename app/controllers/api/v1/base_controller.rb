class Api::V1::BaseController < ApplicationController
  respond_to :json
  before_action :doorkeeper_authorize!
  protect_from_forgery with: :null_session

  protected

  def current_user
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end