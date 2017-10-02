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

  describe 'methods' do
    let(:message) { Message.new }

    describe 'image?' do
      subject(:image?) { message.image? }

      context 'when the type_id is IMAGE_TYPE' do
        before { message.type_id = Message::IMAGE_TYPE }

        it { should be true }
      end

      context 'when the type_id is anything else' do
        [Message::VIDEO_TYPE, Message::TEXT_TYPE].each do |type_id|
          before { message.type_id = type_id }

          it { should be false }
        end
      end
    end

    describe 'video?' do
      subject(:video?) { message.video? }

      context 'when the type_id is VIDEO_TYPE' do
        before { message.type_id = Message::VIDEO_TYPE}

        it { should be true }
      end

      context 'when the type_id is anything else' do
        [Message::IMAGE_TYPE, Message::TEXT_TYPE].each do |type_id|
          before { message.type_id = type_id }

          it { should be false }
        end
      end
    end

    describe 'text?' do
      subject(:text?) { message.text? }

      context 'when the type_id is TEXT_TYPE' do
        before { message.type_id = Message::TEXT_TYPE}

        it { should be true }
      end

      context 'when the type_id is anything else' do
        [Message::IMAGE_TYPE, Message::VIDEO_TYPE].each do |type_id|
          before { message.type_id = type_id }

          it { should be false }
        end
      end
    end

    describe 'media?' do
      subject(:media?) { message.media? }

      context 'when the type_id is VIDEO_TYPE' do
        before { message.type_id = Message::VIDEO_TYPE }

        it { should be true }
      end

      context 'when the type_id is IMAGE_TYPE' do
        before { message.type_id = Message::IMAGE_TYPE }

        it { should be true }
      end

      context 'when the type_id is TEXT_TYPE' do
        before { message.type_id = Message::TEXT_TYPE }

        it { should be false}
      end
    end
  end
end
