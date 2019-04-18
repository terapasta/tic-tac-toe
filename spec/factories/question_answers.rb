FactoryBot.define do
  factory :question_answer do
    sequence(:question) { |n| "question_answers.question #{n}" }
    sequence(:answer) { |n| "question_answers.answer #{n}" }

    trait :with_decision_branches do
      transient do
        branch_count { 2 }
      end

      after(:build) do |qa, evaluator|
        evaluator.branch_count.times do
          qa.decision_branches << build(:decision_branch, bot_id: qa.bot_id)
        end
      end
    end
  end
end
