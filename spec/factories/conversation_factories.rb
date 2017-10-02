FactoryGirl.define do
  factory :conversation do
    transient do
      user nil
      participant_count 2
    end

    after(:create) do |conversation, evaluator|
      create(:participant, user: evaluator.user, conversation: conversation)
      create_list(:participant, evaluator.participant_count - 1, conversation: conversation)
    end
  end
end
