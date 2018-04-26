require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create(:user)}
  let(:user2) {create(:user)}
  let(:question) {FactoryBot.create(:question, user_id: user.id)}
  let(:answer) {FactoryBot.create(:answer, question_id: question.id, user_id: user.id)}

  before do
    sign_in(user)
  end

  describe 'GET #edit' do
    before {get :edit, params: { id: answer }}

    it 'assigns a requested answer to @answer variable' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders an edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let(:new_answer) {build(:answer, question_id: question.id)}

    context 'with valid attributes' do
      it 'expects the new answer is saved in database' do
        expect {post :create, params: { question_id: question.id, answer: new_answer.attributes, format: :js  }}.to change {question.answers.count}.by(1).and change {user.answers.count}.by(1)
      end
    end

    context 'with invalid attributes' do
      let(:bad_answer) {FactoryBot.build(:invalid_answer)}

      it 'does not save the question' do
        expect {post :create, params: { question_id: question.id, answer: bad_answer.attributes, format: :js }}.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        answer.body = 'The new body of the answer'
        patch :update, params: { id: answer, answer: answer.attributes, format: :js }
      end

      it 'updates the answer in the database, if user is the AUTHOR (we use user1)' do
        answer.reload
        expect(answer.body).to eq ('The new body of the answer')
      end
    end

    context 'with invalid params' do
      before do
        answer.body = nil
        patch :update, params: { id: answer, answer: answer.attributes, format: :js }
      end

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq('The body of the answer')
      end
    end

    context 'does not change answer attributes, cause the user is NOT the AUTHOR (we use user2)' do
      before do
        sign_in(user2)
        answer.body = 'The new body of the answer'
        patch :update, params: { id: answer, answer: answer.attributes, format: :js }
      end

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq('The body of the answer')
      end
    end
  end

  describe 'DELETE #destroy' do
    before {answer}

    context 'detele answer by AUTHOR' do
      it 'removes answer' do
        expect {delete :destroy, params: {id: answer}, format: :js}.to change(Answer, :count).by(-1)
      end
    end

    context 'trying to delete answer NOT by the AUTHOR' do
      before {sign_in(user2)}
      it 'should not delete any question' do
        expect {delete :destroy, params: {id: answer}, format: :js}.to_not change(Answer, :count)
      end
    end
  end

  describe 'PUT #mark_the_best' do
    context 'mark the best anwer by AUTHOR of the question' do
      it 'should UPDATE the unswer' do
        patch :mark_the_best, params: { answer_id: answer, format: :js }
        expect(assigns(:answer).is_best ).to eq true
      end
    end

    context 'mark the best answer NOT by the AUTHOR of the question' do
      before {sign_in(user2)}
      it 'should NOT UPDATE the unswer' do
        patch :mark_the_best, params: { answer_id: answer, format: :js }
        expect(assigns(:answer).is_best).to eq false
      end
    end
  end

end
