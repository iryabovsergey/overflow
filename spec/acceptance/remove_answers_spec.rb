require_relative 'acceptance_helper'

feature 'Removing answers', %q{
    user can remove only his own answers
  } do

  given(:user1) {create(:user)}
  given(:user2) {create(:user)}

  given(:answer) {create(:answer, user: user1) }

  scenario 'User removes his own answer', js: true do
    sign_in(user1)
    visit question_path(answer.question)
    page.find("#del_answer_#{answer.id}").click
    page.driver.browser.switch_to.alert.accept unless Capybara.javascript_driver == :webkit

    expect(page).to have_content 'Answer successfully deleted'
    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(answer.question)
  end

  scenario "User tries to remove another's answer" do
    sign_in(user2)
    visit question_path(answer.question)
    expect(page).to_not have_css("#del_answer_#{answer.id}")
  end

  scenario 'non-authericates tries to remove an answer' do
    visit question_path(answer.question)
    expect(page).to_not have_css("#del_answer_#{answer.id}")
  end

end
