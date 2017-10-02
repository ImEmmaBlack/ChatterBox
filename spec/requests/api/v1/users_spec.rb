require 'rails_helper'

describe 'api/v1/users', type: :request do
  let(:current_user) { FactoryGirl.create(:user) }

  it_behaves_like 'an authenticated endpoint', '/api/v1/users'

  before { FactoryGirl.create_list(:user, 5) }
  it 'returs an array of all users on authenticated requests' do
    get '/api/v1/users', headers: auth_headers(current_user)

    expect(response.status).to eq(200)
    expect(json.length).to eq(User.all.count)
    expect(json.map { |u| u['id'] }).to eq(User.all.ids)
  end
end
