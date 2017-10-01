require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many(:conversations) }
    it { should have_many(:participants) }
  end

  describe 'validations' do
    context 'username' do
      it { should validate_presence_of(:username) }
      it { should validate_uniqueness_of(:username) }
      it { should validate_length_of(:username).is_at_least(3) }
    end

    context 'password' do
      it { should validate_presence_of(:password) }
      it { should validate_length_of(:password).is_at_least(6) }
    end

    context 'email' do
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email) }
    end
  end
end

