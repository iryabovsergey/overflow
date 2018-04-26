class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    sign_in_if_user_exists(request.env['omniauth.auth'],'facebook')
  end

  def twitter
    render 'omniauth_callbacks/user_email' unless sign_in_if_user_exists(request.env['omniauth.auth'],'twitter')
  end

  def set_user_email
    if (@user = User.find_by_email(user_params[:email])).present?
      Authorization.where(user_id: params[:id]).update_all(user_id: @user.id)
      User.find(params[:id]).delete
      sign_in_and_redirect @user, event: :authentication
    else
      @user = User.find(params[:id])
      if @user.update(user_params)
        sign_in_and_redirect @user, event: :authentication
      else
        render 'omniauth_callbacks/user_email'
      end
    end
  end

  private

  def sign_in_if_user_exists(auth, auth_provider)
    @user = User.find_for_oauth(auth)
    return false unless @user.persisted?

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: auth_provider) if is_navigational_format?
    true
  end

  def user_params
    params.require(:user).permit(:email)
  end

end
