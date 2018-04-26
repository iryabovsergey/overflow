require_relative 'acceptance_helper'

feature 'Mark the best answer', %q{
  As author of the question,
  I want to be able to mark question asner
  as the best answer
} do


  given(:others_question) {create(:question)}
  given!(:other_answer1) {create(:answer, question: others_question)}
  given!(:other_answer2) {create(:answer, question: others_question)}

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  given!(:answer1) {create(:answer, question: question)}
  given!(:answer2) {create(:answer, question: question)}
  given!(:answer3) {create(:answer, question: question)}


  scenario 'Unathorized user should not see special button' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link("The Best")
    end
  end

  scenario "User should not see special button for OTHER's question" do
    sign_in(user)
    visit question_path(others_question)
    within '.answers' do
      expect(page).to_not have_link("The Best")
    end
  end

  describe 'Authenticated user tries to mark answer as the best', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Author of the question can see mark as best button' do
      within '.answers' do
        within "#actions_answer_#{answer1.id}" do
          expect(page).to have_link('The Best')
          click_on 'The Best'
        end
      end

      within '.best_answer_body' do
        expect(page).to have_content(answer1.body)
      end
    end
  end
end