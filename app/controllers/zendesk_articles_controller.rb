class ZendeskArticlesController < ApplicationController
  include BotUsable

  def update
    bot = bots.find(params[:bot_id])
    fail 'Require zendesk credential' if bot.zendesk_credential.blank?
    client = ZendeskClient.new
    client.get_help_center_data(ZendeskClient.make_client_with(bot.zendesk_credential))
    ActiveRecord::Base.transaction do
      client.import_articles_for!(bot)
    end
    redirect_back(fallback_location: bot_question_answers_path(bot))
  end
end