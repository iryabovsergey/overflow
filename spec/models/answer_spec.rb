require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to :question}
  it {should belong_to :user}
  it {should validate_presence_of :body}

  it_behaves_like 'attachable object'

  it 'should mark as the best answer, only one record' do
    question = create(:question)

    answer1 = create(:answer, question: question, is_best: false)
    answer2 = create(:answer, question: question, is_best: true)

    answer1.mark_the_best
    answer1.reload
    answer2.reload

    expect(answer1.is_best).to eq true
    expect(answer2.is_best).to eq false
  end

  describe 'user can vote for the answer' do
    let(:obj) { create(:answer) }
    it_behaves_like 'votable object'
  end

  describe '.send notification about new answer' do
    let(:user) {create(:user)}
    let!(:question) {create(:question, user: user)}
    let!(:answer) { build(:answer, question: question) }
    let!(:existing_answer) { create(:answer, question: question)}

    it 'should send daily notification to all subscribed users on answer create' do
      expect(InformerJob).to receive(:perform_later).with(answer)
      expect {answer.save! }.to change(question.answers, :count).by(1)
    end

    it 'should NOT send any notification on answer update' do
      expect(InformerJob).to_not receive(:perform_later).with(existing_answer)
      existing_answer.body = 'updated body'
      existing_answer.save
    end


  end
end
