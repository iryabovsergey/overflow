require_relative 'acceptance_helper'

feature 'Editing question', %q{
  As the author,
  I want to be able to edit my question(s).
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:other_question) {create(:question)}


  scenario 'Unauthenticated user CAN NOT see Edit button' do
    visit questions_path
    expect(page).to_not have_link("Edit")
  end


  describe 'Authenticated user tries to edit     HIS OWN     question', js: true do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario "User CAN NOT see edit button for other's question" do
      within "#actions_question_#{other_question.id}" do
        expect(page).to_not have_link('Edit')
      end
    end

    scenario 'User CAN see edit button for his own question' do
      within "#actions_question_#{question.id}" do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'User tries to edit the question with    VALID     attributes' do
      within "#div_question_#{question.id}" do
        click_on 'Edit'
        sleep 1
      end

      within "#form_edit_question_#{question.id}" do
        fill_in 'question_title', with: 'The new title of the question'
        fill_in 'question_body', with: 'The new body of the question'
        click_on 'Submit'
      end

      within "#div_question_#{question.id}" do
        expect(page).to have_content('The new title of the question').and have_content('The new body of the question')
      end

    end

    scenario 'User tries to edit the question with    INVALID    attributes' do
      within "#div_question_#{question.id}" do
        click_on 'Edit'
        sleep 1
      end

      within "#form_edit_question_#{question.id}" do
        fill_in 'question_title', with: ''
        fill_in 'question_body', with: 'The new body of the question'
        click_on 'Submit'
      end

      within "#form_edit_question_#{question.id}" do
        expect(page).to have_content("Title can't be blank")
      end
    end
  end

end