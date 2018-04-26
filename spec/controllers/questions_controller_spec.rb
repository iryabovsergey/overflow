require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }

  before do
    sign_in(user)
  end

  describe 'GET #index' do
    before do
      get :index
      @questions_arr = create_list(:question, 2)
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(@questions_arr)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }
    it 'assigns the requested question to @question' do
      get :show, params: {id: question}
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }
    it 'should assign question to question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'GET #new' do
    before { get :new }
    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    before do
      @question_new = build(:question)
    end

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: @question_new.attributes } }.to change(Question, :count).by(1).and change { user.questions.count }.by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: @question_new.attributes }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'creates subscription for author of the question' do
        expect { post :create, params: { question: @question_new.attributes } }.to change(user.subscriptions, :count).by(1)
      end

      context 'with invalid attributes' do
        bad_question = FactoryBot.build(:invalid_question)

        it 'does not save the question' do
          expect { post :create, params: { question: bad_question.attributes } }.not_to change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: bad_question.attributes }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid atrubutes, by the AUTHOR' do # initially we have logged in as 'user'
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update,  params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload
        expect(question.title).to eq('new title')
        expect(question.body).to eq('new body')
      end
    end

    context 'AUTHOR tries to change the answer with invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil } }, format: :js }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq('A title of the question')
        expect(question.body).to eq('A body of the question')
      end
    end

    context 'trying of change question attributes by NOT the AUTHOR (user2)' do
      before do
        sign_in(user2) # log in as 'user2', initially we have logged in as 'user'. question belongs to 'user'
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        it 'does not change question attributes' do
          expect(question.title).to eq('A title of the question')
          expect(question.body).to eq('A body of the question')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }

    context 'deleting question by AUTHOR' do
      it 'removes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'tring to delete question by NOT the AUTHOR' do
      before do
        sign_in(user2)
      end
      it 'removes question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
