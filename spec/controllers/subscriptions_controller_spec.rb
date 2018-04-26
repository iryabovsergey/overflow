require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:question) { create(:question, user: other_user) }
  let!(:user_question) { create(:question, user: user) }


  let!(:user_subscription) { create(:subscription, user: user) }
  let!(:other_user_user_subscription) { create(:subscription) }


  before do
    sign_in(user)
  end

  describe '(SubscriptionsController#create) user can subscribe to any question' do
    it "creates new subscription record in the database for the particular question" do
      expect { post :create, params: { question_id: question.id}}.to change(Subscription, :count).by(1).and change(question.subscriptions, :count).by(1)
    end

    it "does not create new subscription record in the database if user has already created one" do
      expect { post :create, params: { question_id: user_question.id} }.to_not change(Subscription, :count)
    end
  end


  describe '(SubscriptionsController#destroy) user can destroy the subscription' do
    it "destroys the user's own subscription" do
      expect { delete :destroy, params: { id: user_subscription.id} }.to change(Subscription, :count).by(-1)
    end

    it "does not destroy the other user's own subscription" do
      expect { delete :destroy, params: { id: other_user_user_subscription.id } }.to_not change(Subscription, :count)
    end
  end


end
