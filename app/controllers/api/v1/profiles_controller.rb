class Api::V1::ProfilesController < Api::V1::BaseController
  # load_and_authorize_resource through: :user
  # load_and_authorize_resource
  skip_authorization_check

  def me
    respond_with current_user ? current_user.slice(:id, :name, :email) : nil
  end

  def index
    @users = User.where.not(id: current_user).pluck(:id, :name, :email)
    respond_with @users
  end
end