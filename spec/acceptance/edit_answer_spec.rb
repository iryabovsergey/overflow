require_relative 'acceptance_helper'

feature 'Editing answer', %q{
  To have an ability to fix the mistakes,
  As the author,
  I want to be able to edit the answer.
} do

  given(:user) {create(:user)}
  given(:question) {create(:question)}
  given!(:answer) {create(:answer, question: question, user: user)}
  given!(:others_answer) {create(:answer, question: question)}

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_css(".edit_answer_link")
    end
  end



  describe 'Authenticated user tries to edit answers', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "Authenticated user CAN NOT see 'Edit' button on    OTHER's    answers" do
      within "#actions_answer_#{others_answer.id}" do
        expect(page).to_not have_link('Edit')
      end
    end

    scenario 'User CAN see an edit button' do
      within '.answers' do
        expect(page).to have_css("#edit_answer_link_#{answer.id}")
      end
    end

    scenario 'User CAN NOT update his own answer, with INVALID attrubutes' do
      find("#edit_answer_link_#{answer.id}").click
      within "#form_edit_answer_#{answer.id}" do
        fill_in id: 'answer_body', with: ''
        click_on 'Submit'
      end

      within "#form_edit_answer_#{answer.id}" do
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'User CAN update his own answer, with VALID attributes' do
      find("#edit_answer_link_#{answer.id}").click

      within "#form_edit_answer_#{answer.id}" do
        fill_in 'answer_body', with: 'The body of the just created answer'
        click_on 'Submit'
      end

      within '.answers' do
        expect(page).to have_content('The body of the just created answer')
      end
    end
  end

end



