require_relative 'acceptance_helper'

feature 'Create answers', %q{
      As authenticated user
      I want to be able to create answers } do

  given(:user) {create(:user)}
  given(:question) {create(:question)}

  scenario 'Authenticated user creates answer, and the just created answer appears below the list', js: true do
    sign_in(user)
    expect(page).to have_content("You have signed in as '#{user.name}'")

    visit question_path(question)
    fill_in 'answer_body', with: 'The body of the just created answer'
    click_on 'Submit'

    expect(current_path).to eq question_path(question)

    within '.newly_created_answers' do
      expect(page).to have_content 'The body of the just created answer'
    end
  end

  scenario 'Authenticated user tries to create answer with empty body', js: true do
    sign_in(user)
    expect(page).to have_content("You have signed in as '#{user.name}'")
    visit question_path(question)
    click_on 'Submit'
    expect(page).to have_content "Body can't be blank"
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authericated user tries to create an answer' do
    visit question_path(question)
    expect(page).to have_button('Submit', disabled: true)
    expect(page).to have_field("Body", disabled: true)
  end

  context "The created answer should appear on the page of another user", js:true do
    scenario "Answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer_body', with: 'The body of the just created answer'
        click_on 'Submit'
        expect(page).to have_content 'The body of the just created answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'The body of the just created answer'
      end
    end
  end

end
