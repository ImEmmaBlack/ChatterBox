require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'relationships' do
    it { should have_many(:messages) }
    it { should have_many(:participants) }
    it { should have_many(:users) }
  end

  describe 'methods' do
    let(:conversation) { Conversation.new }

    describe 'add_user' do
      let(:user) { double(:user) }
      after { conversation.add_user(user) }

      it { conversation.participants.should_receive(:create).with(user: user) }
    end

    describe 'add_users' do
      let(:user1) { double(:user) }
      let(:user2) { double(:user) }
      subject(:add_users) { conversation.add_users([user1, user2]) }

      context 'when users are added succesfully' do
        before { allow(conversation.participants).to receive(:create) { true } }

        it 'calls create with each user' do
          expect(conversation.participants).to receive(:create).with(user: user1)
          expect(conversation.participants).to receive(:create).with(user: user2)

          add_users
        end

        it { is_expected.to be true }
      end

      context 'when users are not added succesfully' do
        before { allow(conversation.participants).to receive(:create) { false } }

        it 'calls create until it fails' do
          expect(conversation.participants).to receive(:create).with(user: user1)

          add_users
        end

        it { is_expected.to be false }
      end
    end

    describe 'participant' do
      let(:user_id) { 'user-id' }
      after { conversation.participant(user_id) }

      it { conversation.participants.should_receive(:find_by).with(user_id: user_id) }
    end

    describe 'update_last_message_time' do
      subject(:update_latest_message_time) { conversation.update_latest_message_time(latest_message_time) }
      let(:latest_message_time) { DateTime.current }

      context 'when last_message_at is not nil' do
        before { conversation.last_message_at = Time.current }

        context 'latest_message_time is more recent than last_message_at' do
          before { conversation.last_message_at = latest_message_time.prev_day }

          it 'sets last_message_at to the latest_message_time' do
            expect(conversation).to receive(:update).with(last_message_at: latest_message_time)

            update_latest_message_time
          end
        end

        context 'latest_message_time is less recent than last_message_at' do
          before { conversation.last_message_at = latest_message_time.next_day }

          it 'does not set last_message_at to the latest_message_time' do
            expect(conversation).not_to receive(:update)

            update_latest_message_time
          end
        end

      end

      context 'when last_message_at is nil' do
        before { conversation.last_message_at = nil }

        it 'sets last_message_at to the latest_message_time' do
          expect(conversation).to receive(:update).with(last_message_at: latest_message_time)

          update_latest_message_time
        end
      end
    end

    describe 'notify_all_participants_new_message' do
      subject(:notify_all_participants) { conversation.notify_all_participants_new_message(message_id, sender_id) }
      let(:participant1) { Participant.new(user_id:  'participant_1_user_id') }
      let(:participant2) { Participant.new(user_id:  'participant_2_user_id') }
      let(:sender_id) { 'sender-id' }
      let(:message_id) { 'message-id' }

      before { conversation.participants = [participant1, participant2] }

      it 'broadcasts update information to the participants' do
        expect(ActionCable.server).to receive(:broadcast).with("messages_for_user_#{participant1.user_id}", anything)
        expect(ActionCable.server).to receive(:broadcast).with("messages_for_user_#{participant2.user_id}", anything)

        notify_all_participants
      end
    end

    describe 'notify_all_participants_new_conversation' do
      subject(:notify_all_participants) { conversation.notify_all_participants_new_conversation() }
      let(:participant1) { Participant.new(user_id:  'participant_1_user_id') }
      let(:participant2) { Participant.new(user_id:  'participant_2_user_id') }

      before do
        conversation.participants = [participant1, participant2]
        allow(conversation).to receive(:reload) { conversation }
      end

      it 'broadcasts update information to the participants' do
        expect(ActionCable.server).to receive(:broadcast).with("messages_for_user_#{participant1.user_id}", { conversation_id: conversation.id })
        expect(ActionCable.server).to receive(:broadcast).with("messages_for_user_#{participant2.user_id}", { conversation_id: conversation.id })

        notify_all_participants
      end
    end
  end
end
