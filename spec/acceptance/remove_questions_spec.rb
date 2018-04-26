require_relative 'acceptance_helper'

feature 'Removing question', %q{
    user can remove only his own question
  } do

  given(:user1) {create(:user)}
  given(:user2) {create(:user)}

  given(:question) {create(:question, user_id: user1.id) }

  scenario 'User removes his own question', js: true do
    sign_in(user1)
    visit question_path(question)
    click_on 'Delete question'
    page.driver.browser.switch_to.alert.accept unless Capybara.javascript_driver == :webkit
    expect(page).to have_content 'Question was successfully destroyed'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario "User tries to remove another's question" do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_css('#del_question')
  end

  scenario 'non-authericates tries to remove a question' do
    visit question_path(question)
    expect(page).to_not have_css('#del_question')
  end

end
