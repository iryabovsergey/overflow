require_relative 'acceptance_helper'

feature 'User should have an ability to vote for the answer, if he is not an author of it', %q{
User, who is not the author of the answer, should have an ability
to vote} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, user: user, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  describe "user can see vote buttons for other's answer and can not see for his own answer" do
    scenario "User can not see voting buttons for his own answer" do
      within "#div_answer_#{answer.id}" do
        expect(page).to have_css('.give_vote')
      end
    end

    scenario "User can not see voting buttons for his own answer" do
      within "#div_answer_#{user_answer.id}" do
        expect(page).not_to have_css('.give_vote')
      end
    end
  end

  describe "User can votes +1 and -1 to other's question, user can cancel his voting" do
    scenario "User can votes +1 for other's question", js: true do
      within "#div_answer_#{answer.id}" do
        find('#give_vote_plus').click
      end

      within '.notices' do
        expect(page).to have_content('Your vote make sence')
      end

      within "#score_a_#{answer.id}" do
        expect(page).to have_content('1')
      end
    end

    scenario "User can votes -1 for other's answer", js: true do
      within "#div_answer_#{answer.id}" do
        find('#give_vote_minus').click
      end

      within '.notices' do
        expect(page).to have_content('Your vote make sence')
      end

      within "#score_a_#{answer.id}" do
        expect(page).to have_content('-1')
      end
    end

    scenario "User can cancel his voting for other's answer", js: true do
      vote = create(:vote, votable: answer, user: user, vote: 1)

      within "#div_answer_#{answer.id}" do
        find('#give_vote_cancel').click
      end

      within '.notices' do
        expect(page).to have_content('Your vote make sence')
      end

      within "#score_a_#{answer.id}" do
        expect(page).to have_content('0')
      end
    end

  end


  describe "INVALID VOTING. User can't vote more than once (+1 and -1) for other's answer, user can cancel his voting, if he did not vote yet" do
    scenario "User can votes +1 for other's answer", js: true do
      vote = create(:vote, votable: answer, user: user, vote: 1)
      visit question_path(question)

      within "#div_answer_#{answer.id}" do
        find('#give_vote_plus').click
      end

      within '.errors' do
        expect(page).to have_content("User You have already voted. You can't vote twice")
      end

      within "#score_a_#{answer.id}" do
        expect(page).to have_content('1')
      end
    end

    scenario "User can votes -1 for other's votable:", js: true do
      vote = create(:vote, votable: answer, user: user, vote: 1)
      visit question_path(question)

      within "#div_answer_#{answer.id}" do
        find('#give_vote_minus').click
      end

      within '.errors' do
        expect(page).to have_content("User You have already voted. You can't vote twice")
      end

      within "#score_a_#{answer.id}" do
        expect(page).to have_content('1')
      end
    end

    scenario "User can not cancel his voting for other's answer, if he has never voted", js: true do
      within "#div_answer_#{answer.id}" do
        find('#give_vote_cancel').click
      end

      within '.errors' do
        expect(page).to have_content('You did not vote for this record yet')
      end

      within "#score_a_#{answer.id}" do
        expect(page).to have_content('0')
      end
    end

  end


end