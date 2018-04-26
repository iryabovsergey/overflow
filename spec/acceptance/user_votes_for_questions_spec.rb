require_relative 'acceptance_helper'

feature 'User sould be able to vote for questions', %q{
If user is not an author of the question, he can vote for it, and he can cancel his vote} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:user_question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit questions_path
  end

  describe "user can see vote buttons for other's queston and can not see for his own question" do
    scenario "User can not see voting buttons for his own question" do
      within "#div_question_#{question.id}" do
        expect(page).to have_css('.give_vote')
      end
    end

    scenario "User can not see voting buttons for his own question" do
      within "#div_question_#{user_question.id}" do
        expect(page).not_to have_css('.give_vote')
      end
    end
  end

  describe "User can votes +1 and -1 to other's question, user can cancel his voting" do
    scenario "User can votes +1 for other's question", js: true do
      
      within "#div_question_#{question.id}" do
        find('#give_vote_plus').click
      end

      within '.notices' do
        expect(page).to have_content('Your vote make sence')
      end

      within "#score_q_#{question.id}" do
        expect(page).to have_content('1')
      end
    end

    scenario "User can votes -1 for other's question", js: true do
      within "#div_question_#{question.id}" do
        find('#give_vote_minus').click
      end

      within '.notices' do
        expect(page).to have_content('Your vote make sence')
      end

      within "#score_q_#{question.id}" do
        expect(page).to have_content('-1')
      end
    end

    scenario "User can cancel his voting for other's question", js: true do
      vote = create(:vote, votable: question, user: user, vote: 1)

      within "#div_question_#{question.id}" do
        find('#give_vote_cancel').click
      end

      within '.notices' do
        expect(page).to have_content('Your vote make sence')
      end

      within "#score_q_#{question.id}" do
        expect(page).to have_content('0')
      end
    end

  end


  describe "INVALID VOTING. User can't vote more than once (+1 and -1) to other's question, user can cancel his voting, if he did not vote yet" do
    scenario "User can votes +1 for other's question", js: true do
      vote = create(:vote, votable: question, user: user, vote: 1)
      visit questions_path
      within "#div_question_#{question.id}" do
        find('#give_vote_plus').click
      end

      within '.errors' do
        expect(page).to have_content("User You have already voted. You can't vote twice")
      end

      within "#score_q_#{question.id}" do
        expect(page).to have_content('1')
      end
    end

    scenario "User can votes -1 for other's question", js: true do
      vote = create(:vote, votable: question, user: user, vote: 1)
      visit questions_path
      within "#div_question_#{question.id}" do
        find('#give_vote_minus').click
      end

      within '.errors' do
        expect(page).to have_content("User You have already voted. You can't vote twice")
      end

      within "#score_q_#{question.id}" do
        expect(page).to have_content('1')
      end
    end

    scenario "User can cancel his voting for other's question", js: true do
      within "#div_question_#{question.id}" do
        find('#give_vote_cancel').click
      end

      within '.errors' do
        expect(page).to have_content('You did not vote for this record yet')
      end

      within "#score_q_#{question.id}" do
        expect(page).to have_content('0')
      end
    end

  end


end