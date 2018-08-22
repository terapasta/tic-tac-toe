class ChatworkDecisionBranchSerializer < ActiveModel::Serializer
  attributes :access_token, :decision_branch_body

  def decision_branch_body
    object.decision_branch&.body || ''
  end
end