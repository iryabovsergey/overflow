shared_examples_for "API Authenticable (get)" do
    it 'returns 401 status if there is no access_token' do
      get get_path, headers: {accept: 'application/json'}
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      get get_path, params: {access_token: '1234'}, headers: {accept: 'application/json'}
      expect(response.status).to eq 401
    end
end

