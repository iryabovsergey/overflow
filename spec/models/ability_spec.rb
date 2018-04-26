require 'spec_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user, admin: false) }
    let(:other_user) { create(:user, admin: false) }
    let(:answer) { create(:answer, user: other_user) }
    let(:user_answer) { create(:answer, user: user) }
    let(:question) { create(:question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }


    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }


    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }

    it { should be_able_to :create, Vote.new(user: user, votable: answer), user: user }
    it { should_not be_able_to :create, Vote.new(user: user, votable: user_answer), user: user }

    it { should be_able_to :destroy, Vote.create(user: user, votable: answer), user: user }
    it { should_not be_able_to :destroy, Vote.create(user: other_user, votable: user_answer), user: user }

    it { should be_able_to :create, Subscription.new(user: user, question: question), user: user }

    it { should be_able_to :destroy, Subscription.create(user: user, question: question), user: user }
    it { should_not be_able_to :destroy, Subscription.create(user: other_user, question: question), user: user }
  end


end