FactoryGirl.define do
  factory :decision_branch do
    bot
    answer
    sequence(:body) { |n| "decision_branches.body #{n}" }
  end
end
