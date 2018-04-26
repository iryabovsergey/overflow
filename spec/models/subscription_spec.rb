require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it {should belong_to :user}
  it { should belong_to :question }

  it 'combination of user and question object must be uniq' do
    question = create(:question)
    user = create(:user)
    s1 = create(:subscription, question: question,  user: user)
    s2 = build(:subscription, question: question,  user: user)
    s2.save

    expect(s2.errors.full_messages[0]).to eq "User You have already subscribed to the question"
  end
end
