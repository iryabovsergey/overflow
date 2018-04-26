require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let(:other_user) { create(:user) }
  let(:other_question) { create(:question, user: other_user) }
  let(:user) { create(:user) }
  let(:user_question) { create(:question, user: user) }

  # other_user has already voted for question
  let(:vote) { create(:vote, user: other_user, votable: user_question) }

  before do
    sign_in(user)
  end

  describe '(Vote_controller#give_vote) user votes for question' do

    context "VALID voting: user votes for other's question for the first time" do
      it "creates new record in the database, score is changed" do
        expect { post :create, params: { question_id: other_question.id, vote: 'plus', votable_class: 'Question' }, format: :json }.to change(Vote, :count).by(1).and change { other_question.score }.to(1)
      end
    end


    context "INVALID voting:" do
      before do
        sign_in(other_user)
      end

      it "user votes the second time, it does NOT creates new record in the database" do
        vote
        expect { post :create, params: { question_id: user_question.id, vote: 'plus', votable_class: 'Question' }, format: :json }.to_not change(Vote, :count)
      end

      it "user votes for his own question, it does NOT creates new record in the database" do
        expect { post :create, params: { question_id: other_question.id, vote: 'plus', votable_class: 'Question' }, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe '(Vote_controller#destroy) user cancels his voting for question' do
    before do
      sign_in(other_user)
    end

    it "removes object from database" do
      vote
      expect { delete :destroy, params: { question_id: user_question.id, id: 0, votable_class: 'Question' }, format: :json }.to change(Vote, :count).by(-1)
    end
  end


end
