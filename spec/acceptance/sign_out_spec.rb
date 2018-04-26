require_relative 'acceptance_helper'

feature 'user sign out', %q{
  I'm the user.
  I want to be able to sign out.
} do

  given(:user) { create(:user)}

  scenario 'Signed in user try to sign out' do
    sign_in(user)
    click_on 'Sign out'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end

end