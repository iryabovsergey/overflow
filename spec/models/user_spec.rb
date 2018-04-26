require 'rails_helper'

RSpec.describe User, type: :model do
  it {should validate_presence_of :name}
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}

  it 'author_of? function should return false cause user is NOT author of question' do
    user = create(:user)
    question = create(:question)
    expect(user).to_not be_author_of(question)
  end

  it 'author_of? function should return true cause user is author of question' do
    user = create(:user)
    question = create(:question, user: user)
    expect(user).to be_author_of(question)
  end

  describe '.find_for_oauth' do
    let!(:user) {create(:user)}
    let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456')}

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: user.email})}

        it 'should not create new user' do
          expect {User.find_for_oauth(auth)}.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect {User.find_for_oauth(auth)}.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth[:provider]
          expect(authorization.uid).to eq auth[:uid]
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

      end

      context 'user does not exist' do
        let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new@user.com'})}

        it 'create new user' do
          expect {User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end
        it 'return new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fill new email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth[:info][:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context 'user does not exist, and email is empty' do
        let(:auth) {OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: {emails: ''})}

        it 'create new user' do
          expect {User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end

        it 'expect the email of created user is temporary' do
          user = User.find_for_oauth(auth)
          expect(user.email.include? '@temporary_generated_email.xyz').to eq true
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
      end
    end
  end

  describe '.send daily digest' do
    let!(:users) {FactoryBot::create_list(:user, 2)}
    it 'should send daily digest to all users' do
      users.each {|user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end

end
