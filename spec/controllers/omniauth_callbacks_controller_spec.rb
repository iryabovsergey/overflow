require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user, email: 'abcdefgh@temporary_generated_email.xyz') }
  let(:auth) { create(:authorization, user: user) }
  let(:another_user) { create(:user, email: 'existing@email.com') }
  before do
    request.env["devise.mapping"] = Devise.mappings[:user] # If using Devise
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    another_user
    auth
  end

  describe 'PATCH #set_user_email' do
    it 'saves a correct email' do
      patch :set_user_email, params: { id: user.id, user: { email: 'correct@email.com' } }
      expect(assigns(:user)).to eq user
      user.reload
      expect(user.email).to eq('correct@email.com')
    end

    it 'does not save an empty email' do
      patch :set_user_email, params: {id: user.id, user: { email: '' } }
      expect(assigns(:user)).to eq user
      user.reload
      expect(user.email).to eq('abcdefgh@temporary_generated_email.xyz')
    end

    it 'finds a user with the email, reassign authorization to the found user' do
      patch :set_user_email, params: { id: user.id, user: { email: 'existing@email.com' } }
      expect(assigns(:user).email).to eq 'existing@email.com'
      auth.reload
      expect(auth.user).to eq another_user
    end

    it 'removes newly creates user if email has been found in database' do
      expect { patch :set_user_email, params: { id: user.id, user: { email: 'existing@email.com' } } }.to change(User, :count).by(-1)
    end

  end


end
