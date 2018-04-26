require_relative 'acceptance_helper'

feature 'user sign up', %q{
  I'm a new user.
  I want to be able to sign up.
} do
  scenario 'User tries to sign up with VALID information' do
    visit new_user_registration_path
    fill_in 'Email', with: 'correct_user@test.com'
    fill_in 'Name', with: 'John'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with INVALID information' do
    visit new_user_registration_path
    fill_in 'Email', with: 'correct_user@test.com'
    fill_in 'Name', with: ''
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(current_path).to eq user_registration_path
  end

end