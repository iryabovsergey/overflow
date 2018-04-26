require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before do
    sign_in(user)
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:comment) { build(:comment, user: user, commentable: question) }

      it 'saves the new comment in the database, and bind it to question' do
        expect { post :create, params: {question_id: question.id, comment: comment.attributes}, format: :js }.to change(Comment, :count).by(1).and change { question.comments.count }.by(1)
      end
    end


    context 'with invalid attributes' do
      let(:bad_comment) { build(:invalid_comment, user: user, commentable: question) }

      it 'does not save the comment' do
        expect { post :create, params: {question_id: question.id, comment: bad_comment.attributes}, format: :js }.not_to change(Comment, :count)
      end
    end
  end


end
