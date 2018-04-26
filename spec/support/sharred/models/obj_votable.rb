shared_examples_for 'votable object' do
  it 'should return correct update score' do
    create(:vote, votable: obj, vote: 1)
    create(:vote, votable: obj, vote: 1)
    create(:vote, votable: obj, vote: -1)
    create(:vote, votable: obj, vote: 1)

    expect(obj.score).to eq 2
  end
end