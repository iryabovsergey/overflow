require_relative 'acceptance_helper'
feature 'Authorized user should have an ability to add comments to answers' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question:question) }


  describe "Not authorized user does not see 'Add comment' button; authorized user can see the button" do
    scenario "User can NOT see 'add comments' button, if he is not logged in" do
      visit question_path(question)
      expect(page).to_not have_css('.add_comment')
    end

    scenario "User can see 'add comments' button, if he is not logged in" do
      sign_in(user)
      expect(page).to have_css('.add_comment')
    end
  end

  describe "Authorized user tries to adds comment for answer", js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "User can add valid comment and can see it" do
      within "#div_answer_#{answer.id}" do
        click_on('Add comment')
        fill_in 'Body', with: 'Just a new comment'
        click_on('Submit')
        expect(page).to have_content('Just a new comment')
        expect(current_path).to eq question_path(question)
      end
    end

    scenario "User can not add INVALID comment" do
      within "#div_answer_#{answer.id}" do
        click_on('Add comment')
        fill_in 'Body', with: ''
        click_on('Submit')
        expect(page).to have_content("Body can't be blank")
        expect(current_path).to eq question_path(question)
      end
    end
  end

  context "The created comment should appear on the page of another user", js:true do
    scenario "Comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on('Add comment')
        fill_in 'Body', with: "Just a new comment, should be visible on another user's page"
        click_on('Submit')
        expect(page).to have_content("Just a new comment, should be visible on another user's page")
      end

      Capybara.using_session('guest') do
        expect(page).to have_content "Just a new comment, should be visible on another user's page"
      end
    end
  end



end