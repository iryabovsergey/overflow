require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js, :json

  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  before_action :gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js { render text: 'error', status: 403}
    end
  end

  def default_serializer_options
    {root: false}
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end


end
