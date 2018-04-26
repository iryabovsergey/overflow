module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    # save_and_open_page
    click_on 'Log in'
    sleep(1.5)
  end
end