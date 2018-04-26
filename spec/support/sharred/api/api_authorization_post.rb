shared_examples_for "API Authenticable (post)" do
  it 'returns 401 status if there is no access_token' do
    post post_path, headers: {accept: 'application/json', content_type: 'application/json', authorization: ""}
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access_token is invalid' do
    post post_path, headers: {accept: 'application/json', content_type: 'application/json', authorization: "12345"}
    expect(response.status).to eq 401
  end
end