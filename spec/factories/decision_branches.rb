FactoryGirl.define do
  factory :decision_branch do
    bot
    sequence(:body) { |n| "decision_branches.body #{n}" }
    sequence(:answer) { |n| "decision_branches.answer #{n}" }
  end
end
