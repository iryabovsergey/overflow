require 'rails_helper'

describe 'Profile API' do

  describe 'GET /profiles unauthorized' do
    let(:get_path) {'/api/v1/profiles'}
    it_behaves_like 'API Authenticable (get)'
  end

  describe 'GET /profiles authorized' do
    let!(:me) {create(:user)}
    let!(:other_user) {create(:user)}
    let!(:access_token) {create(:access_token, resource_owner_id: me.id)}

    before {get '/api/v1/profiles', params: {access_token: access_token.token}, headers: {accept: "application/json"}}

    it 'returns 200 status' do
      expect(response).to be_success
    end

    it 'does NOT contain current user' do
      expect(response.body).to_not include_json(me.slice(:id, :name, :email).to_json)
    end

    it 'contains other user' do
      expect(response.body).to_not include_json(other_user.slice(:id, :name, :email).to_json)
    end

    %w(password encrypted_password).each do |attr|
      it "does not contain #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end

  describe 'GET /me unauthorized' do
    let(:get_path) {'/api/v1/profiles/me'}
    it_behaves_like 'API Authenticable (get)'
  end

  context 'GET /me authorized' do
    let(:me) {create(:user)}
    let!(:access_token) {create(:access_token, resource_owner_id: me.id)}

    before do
      get '/api/v1/profiles/me', params: {access_token: access_token.token}, headers: {accept: "application/json"}
    end

    it 'returns 200 status' do
      expect(response).to be_success
    end

    %w(id email name).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
      end
    end

    %w(password encrypted_password).each do |attr|
      it "does not contain #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end
end