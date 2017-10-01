require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe 'relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
  end

  describe 'after_initialize' do
    let(:participant) { Participant.new }

    specify { expect(participant.active).to be true }
    specify { expect(participant.active_since).not_to be nil }
  end
end
