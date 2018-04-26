require 'rails_helper'

RSpec.describe Question, type: :model do
  it {should belong_to :user}
  it {should have_many(:answers).dependent(:destroy)}

  it {should validate_presence_of :title}
  it {should validate_presence_of :body}

  it_behaves_like 'attachable object'

  describe 'user can vote for the question' do
    let(:obj) {create(:question)}
    it_behaves_like 'votable object'
  end

  describe 'when question is being created' do
    let(:question1) {create(:question)}
    it 'it also creates a subscription' do
      expect(question1.subscriptions.count).to eq(1)
    end
  end
end