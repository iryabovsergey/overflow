require 'rails_helper'

describe 'Questions API' do

  describe 'GET /show' do
    let!(:question) {create(:question)}
    context 'unauthorized' do
      let(:get_path) {"/api/v1/questions/#{question.id}"}
      it_behaves_like 'API Authenticable (get)'
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let(:question) {create(:question)}
      let!(:answer) {create(:answer, question: question)}
      let!(:attachment1) {create(:attachment, attachmentable_id: question.id, attachmentable_type: "Question")}
      let!(:comment1) {create(:comment, commentable_id: question.id, commentable_type: "Question")}
      let(:json_root) {''}

      before {get "/api/v1/questions/#{question.id}", params: {access_token: access_token.token}, headers: {accept: 'application/json'}}

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it_behaves_like 'normal question will all the fields'
    end


    describe 'GET /index' do
      context 'unauthorized' do
        let(:get_path) {'/api/v1/questions'}
        it_behaves_like 'API Authenticable (get)'
      end

      context 'authorized' do
        let(:access_token) {create(:access_token)}
        let!(:questions) {create_list(:question, 2)}
        let(:question) {questions.first}
        let!(:answer) {create(:answer, question: question)}
        let!(:attachment1) {create(:attachment, attachmentable_id: question.id, attachmentable_type: "Question")}
        let!(:comment1) {create(:comment, commentable_id: question.id, commentable_type: "Question")}
        let(:json_root) {'0/'}
        before {get '/api/v1/questions', params: {access_token: access_token.token}, headers: {accept: 'application/json'}}
        it 'returns 200 status code' do
          expect(response).to be_success
        end

        it 'returns list of questions' do
          expect(response.body).to have_json_size(2).at_path("/")
        end
        it_behaves_like 'normal question will all the fields'
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      let(:post_path) {'/api/v1/questions'}
      it_behaves_like 'API Authenticable (post)'
    end

    context 'authorized, request with correct params' do
      let(:access_token) {create(:access_token)}

      context 'post request with correct params' do
        before do
          params = {question: {title: "The title", body: "The test answer"}}
          post "/api/v1/questions", params: params, headers: {accept: 'application/json', content_type: 'application/json', authorization: "Bearer #{access_token.token}"}
        end

        it 'returns 201 status code' do
          expect(response.status).to eq 201
        end

        %w(id body title created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to have_json_path(attr)
          end
        end
      end

      context 'authorized, request with WRONG params' do
        let(:access_token) {create(:access_token)}

        before do
          params = {question: {title: "", body: ""}}
          post "/api/v1/questions", params: params, headers: {accept: 'application/json', content_type: 'application/json', authorization: "Bearer #{access_token.token}"}
        end

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end

        it 'has correct errors messages' do
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/title/0')
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0')
        end
      end
    end
  end
end