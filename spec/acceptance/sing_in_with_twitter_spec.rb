require_relative 'acceptance_helper'

feature 'user sign up', %q{
  I want to be able to sign in with twitter.
} do

  before do
    OmniAuth.config.test_mode = true
  end

  scenario 'User tries to sign in with twitter with VALID credentials' do
    visit new_user_session_path
    mock_auth_hash
    page.should have_content("Sign in with Twitter")
    click_on "Sign in with Twitter"
    page.should have_content('Please enter your email')
    click_on 'Submit'
    page.should have_content("Email can't be blank")
    fill_in 'user_email', with: 'correct_user@test.com'
    click_on 'Submit'
    page.should have_content("mockuser")
    page.should have_content("Sign out")
  end

  scenario 'User tries to sign in with twitter with VALID credentials' do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    visit new_user_session_path
    page.should have_content("Sign in with Twitter")
    click_link "Sign in with Twitter"
    page.should have_content('Could not authenticate you from Twitter because "Invalid credentials"')
  end
end
