class ChatworkDecisionBranchJob < ApplicationJob
  def perform(bot, chat, decision_branch, chatwork_decision_branch)
    conn = Faraday.new(url: ENV['MYOPE_BOT_FRAMEWORK_HOST'])

    res = conn.post do |req|
      req.url "/chatwork/#{bot.token}/#{chat.id}"
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        decision_branch_id: decision_branch.id,
        decision_branch_body: decision_branch.body,
        room_id: chatwork_decision_branch.room_id,
        from_account_id: chatwork_decision_branch.from_account_id
      }.to_json
    end
  end
end