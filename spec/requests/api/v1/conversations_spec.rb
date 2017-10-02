require 'rails_helper'

describe 'api/v1/conversations', type: :request do
  let(:current_user) { FactoryGirl.create(:user) }

  it_behaves_like 'an authenticated endpoint', '/api/v1/conversations'

  describe 'index' do
    before { FactoryGirl.create(:conversation, user: current_user) }
    it 'returs an array of a users conversations' do
      get '/api/v1/conversations', headers: auth_headers(current_user)

      expect(response.status).to eq(200)
      expect(json.length).to eq(current_user.conversations.count)
      expect(json.map { |u| u['id'] }).to eq(current_user.conversations.ids)
    end

    it 'does not return conversations from other users' do
      other_user = FactoryGirl.create(:user)
      other_users_conversation = FactoryGirl.create(:conversation, user: other_user)
      get '/api/v1/conversations', headers: auth_headers(current_user)

      expect(json.map { |c| c['id'] }).not_to include other_users_conversation.id
    end
  end
end

