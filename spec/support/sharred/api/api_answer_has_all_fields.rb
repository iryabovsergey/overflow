shared_examples_for 'answer with all the needed fields' do

  %w(id body created_at updated_at).each do |attr|
    it "contains #{attr}" do
      expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{json_root}#{attr}")
    end
  end

  it 'answer has comments' do
    expect(response.body).to have_json_size(1).at_path("#{json_root}comments")
  end

  it 'the comment body is correct' do
    expect(response.body).to be_json_eql(comment2.body.to_json).at_path("#{json_root}comments/0/body")
  end

  it 'answer has attachments' do
    expect(response.body).to have_json_size(1).at_path("#{json_root}attachments")
  end

  it 'the attachments url is correct' do
    expect(response.body).to be_json_eql(attachment2.file.url.to_json).at_path("#{json_root}attachments/0/file_url")
  end

end
