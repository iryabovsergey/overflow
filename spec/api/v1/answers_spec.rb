require 'rails_helper'

describe 'Answers API' do

  describe 'GET /show' do
    let(:answer) {create(:answer)}
    context 'unauthorized' do
      let(:get_path) {"/api/v1/answers/#{answer.id}"}
      it_behaves_like 'API Authenticable (get)'
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:attachment2) {create(:attachment_2, attachmentable_id: answer.id, attachmentable_type: "Answer")}
      let!(:comment2) {create(:comment, commentable_id: answer.id, commentable_type: "Answer")}
      let(:json_root) {''}

      before {get "/api/v1/answers/#{answer.id}", params: {access_token: access_token.token}, headers: {accept: 'application/json'}}

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it_behaves_like 'answer with all the needed fields'
    end
  end

  describe 'GET /index' do
    let(:question) {create(:question)}
    let!(:answer) {create(:answer, question: question)}
    let!(:answer2) {create(:answer, question: question)}

    context 'unauthorized' do
      let(:get_path) {"/api/v1/questions/#{question.id}/answers"}
      it_behaves_like 'API Authenticable (get)'
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:attachment2) {create(:attachment_2, attachmentable_id: answer.id, attachmentable_type: "Answer")}
      let!(:comment2) {create(:comment, commentable_id: answer.id, commentable_type: "Answer")}
      let(:json_root) {'0/'}

      before {get "/api/v1/questions/#{question.id}/answers", params: {access_token: access_token.token}, headers: {accept: 'application/json'}}

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'contains array of answers' do
        expect(response.body).to have_json_size(2).at_path("/")
      end

      it_behaves_like 'answer with all the needed fields'
    end
  end

  describe 'POST /create' do
    let(:question) {create(:question)}

    context 'unauthorized' do
      let(:post_path) {"/api/v1/questions/#{question.id}/answers"}
      it_behaves_like 'API Authenticable (post)'
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      context 'post request with correct params' do
        before do
          a_params = {answer: {body: "The test answer"}}
          post "/api/v1/questions/#{question.id}/answers", params: a_params, headers: {accept: 'application/json', content_type: 'application/json', authorization: "Bearer #{access_token.token}"}
        end

        it 'returns 201 status code' do
          expect(response.status).to eq 201
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to have_json_path(attr)
          end
        end
      end
    end

    context 'post request with wrong params' do
      let(:access_token) {create(:access_token)}
      before do
        a_params = {answer: {body: ""}}
        post "/api/v1/questions/#{question.id}/answers", params: a_params, headers: {accept: 'application/json', content_type: 'application/json', authorization: "Bearer #{access_token.token}"}
      end
      it 'returns 422 status code' do
        expect(response.status).to eq 422
      end

      it 'has correct errors messages' do
        expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0')
      end
    end
  end
end