class ApplicationSummarizer
  StartingDay = :monday
  HalfYearDays = 182
  HalfYearWeeks = HalfYearDays / 7

  def self.type_name
    name.sub(/Summarizer$/, '')
  end

  def self.delete_all
    DataSummary.where(type_name: type_name).delete_all
  end

  def type_name
    self.class.type_name
  end

  def build
    DataSummary.new(
      bot: @bot,
      type_name: type_name,
      data: as_json,
      created_at: @created_at
    )
  end

  def save!
    build.save!
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

  def summarize
    fail 'must implement #summarize method'
  end

  def as_json
    fail 'must implement #as_json method'
  end
end