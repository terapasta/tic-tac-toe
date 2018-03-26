class ApplicationSummarizer
  def self.type_name
    name.sub(/Summarizer$/, '')
  end

  def type_name
    self.class.type_name
  end

  def save!
    DataSummary.create!(
      bot: @bot,
      type_name: type_name,
      data: as_json
    )
  end

  def save
    save!
  rescue => e
    Rails.logger.error e.inspect + e.backtrace.join("\n")
    false
  end

  def get_between(start_time:, end_time:)
    DataSummary.where(
      bot_id: @bot.id,
      type_name: type_name,
      created_at: (start_time..end_time)
    )
  end
end