class BotWordMappingApplyJob < ApplicationJob
  def perform(bot_id)
    WordMapping.replace_synonym_all!(bot_id)
  end
end