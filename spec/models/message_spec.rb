require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'relationships' do
    it { should belong_to(:conversation) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:type_id).in_array((0..2).to_a) }

    describe 'type specific validations' do
      subject(:message) { Message.new }

      context 'when text' do
        before { message.type_id = Message::TEXT_TYPE }

        it { should validate_presence_of(:body) }
        it { should_not validate_presence_of(:url) }
      end

      context 'when image' do
        before { message.type_id = Message::IMAGE_TYPE }

        it { should_not validate_presence_of(:body) }
        it { should validate_presence_of(:url) }
      end

      context 'when video' do
        before { message.type_id = Message::IMAGE_TYPE }

        it { should_not validate_presence_of(:body) }
        it { should validate_presence_of(:url) }
      end
    end
  end
end
