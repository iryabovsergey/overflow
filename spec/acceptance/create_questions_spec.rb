require_relative 'acceptance_helper'

feature 'Create question', %q{
      In order to get answer
      As authetcated user
      I want to be able to ask questions } do

  given(:user) {create(:user)}

  scenario 'Authericates user creates question', js: true do
    sign_in(user)
    visit questions_path
    click_on 'New question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'THE BODY OF THE QUESTION'
    click_on 'Submit'
    expect(page).to have_content 'Question was successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'THE BODY OF THE QUESTION'
  end

  scenario 'Authericates user tries to creates question with empty body and title', js: true do
    sign_in(user)
    visit questions_path

    click_on 'New question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Submit'
    expect(page).to have_content '2 errors prohibited this question from being saved'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  context "The created question should appear on the page of another user", js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'New question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'THE BODY OF THE QUESTION'
        click_on 'Submit'
        expect(page).to have_content 'Question was successfully created'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'THE BODY OF THE QUESTION'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end


  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    expect(page).to_not have_link('New question')
  end
end