require 'rails_helper'

RSpec.describe '/api/bots/:bot_id/question_answers', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:user) do
    create(:user)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:question_answers) do
    create_list(:question_answer, 3, bot: bot)
  end

  let!(:decision_branches) do
    question_answers.map{ |qa|
      create(:decision_branch, bot: bot, question_answer: qa).tap do |db|
        create(:decision_branch, bot: bot, parent_decision_branch_id: db.id)
      end
    }
  end

  before do
    login_as(user, scope: :user)
  end

  describe '?data_format=tree' do
    it 'returns tree data' do
      get "/api/bots/#{bot.id}/question_answers.json?data_format=tree&per=1"

      JSON.parse(response.body).tap do |json|
        expect(json['questionsTree'].first).to eq(
          {
            'id' => question_answers.first.id,
            'decisionBranches' => [
              {
                'id' => decision_branches.first.id,
                'parentQuestionAnswerId' => question_answers.first.id,
                'parentDecisionBranchId' => nil,
                'childDecisionBranches' => [
                  {
                    'id' => decision_branches.first.child_decision_branches.first.id,
                    'parentQuestionAnswerId' => nil,
                    'parentDecisionBranchId' => decision_branches.first.id,
                    'childDecisionBranches' =>  []
                  }
                ]
              }
            ]
          }
        )
        expect(json['searchIndex']).to be_present
        expect(json['questionsRepo']).to be_present
      end
    end
  end
end