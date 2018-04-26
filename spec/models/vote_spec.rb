require 'rails_helper'

RSpec.describe Vote, type: :model do
  it {should belong_to :user}
  it { should belong_to :votable }

  it 'combination of user and attachmentable object must be uniq (user can not vote twice)' do
    question = create(:question)
    vote_prev = create(:vote, votable: question )
    vote = build(:vote, user: vote_prev.user, votable: vote_prev.votable)
    vote.save

    expect(vote.errors.full_messages[0]).to eq "User You have already voted. You can't vote twice"
  end

  it 'the votable record user must not be the same that the record author (user can not vote for his record)' do
    user = create(:user)
    user
    question = create(:question, user: user)
    question
    vote = build(:vote, user: user, votable: question)
    vote.save
    expect(vote.errors.full_messages[0]).to eq "You can't vote for your own record"
  end
end
