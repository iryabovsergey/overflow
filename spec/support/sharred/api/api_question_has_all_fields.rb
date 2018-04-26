shared_examples_for "normal question will all the fields" do
  %w(id title body created_at updated_at).each do |attr|
    it "question object contains #{attr}" do
      expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{json_root}#{attr}")
    end
  end

  it 'question object contains short_title' do
    expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("#{json_root}short_title")
  end

  it 'question object contains attachments' do
    expect(response.body).to have_json_size(1).at_path("#{json_root}attachments")
  end

  it 'attachment URLs are correct' do
    expect(response.body).to be_json_eql(attachment1.file.url.to_json).at_path("#{json_root}attachments/0/file_url")
  end

  it 'question object contains comments' do
    expect(response.body).to have_json_size(1).at_path("#{json_root}comments")
  end

  it 'comment body is correct' do
    expect(response.body).to be_json_eql(comment1.body.to_json).at_path("#{json_root}comments/0/body")
  end

  context 'answers' do
    it 'included in question object' do
      expect(response.body).to have_json_size(1).at_path("#{json_root}answers")
    end

    %w(id body created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{json_root}answers/0/#{attr}")
      end
    end
  end
end