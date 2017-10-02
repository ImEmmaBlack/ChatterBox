RSpec.shared_examples 'an authenticated endpoint' do |url|
  it 'rejects unauthenticated requests' do
    headers = { 'CONTENT_TYPE' => 'application/json', 'Authorization' => 'bearer badToken' }

    get url, headers: headers
    expect(response.status).to eq(401)
  end
end
