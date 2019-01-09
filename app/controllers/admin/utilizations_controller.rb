class Admin::UtilizationsController < ApplicationController
  CookieKey = :watching_bot_ids

  helper_method :watching_bot_ids

  def index
    @watching_bot_ids = watching_bot_ids
    if @watching_bot_ids.blank? || params[:selecting].present?
      render :bot_selector and return
    end
    @bots = Bot.where(id: watching_bot_ids).order(created_at: :desc)

    @data_list = @bots.inject({}) { |acc, bot|
      gm_summarizer = GuestMessagesSummarizer.new(bot)
      qa_summarizer = QuestionAnswersSummarizer.new(bot)
      data = ApplicationSummarizer.aggregate_data(gm_summarizer.half_year_data, qa_summarizer.half_year_data)

      # データが１件もない場合は nil になるので、その場合の max は 0 とする
      # https://www.pivotaltracker.com/n/projects/1879711/stories/161669875
      max = data.drop(1).map{ |d| d.drop(1).max }.compact.max || 0
      level = if max >= 500
                :high
              elsif max >= 300
                :middle
              else
                :low
              end
      acc[level] ||= []
      acc[level] << {
        bot: bot,
        data: data,
        max: max
      }
      acc
    }
    [:high, :middle, :low].each{ |level|
      Array(@data_list[level]).sort_by!{ |it| it[:max] }.reverse!
    }
  end

  def create
    cookies[CookieKey] = {
      value: params[:bot_ids].map(&:to_i).join(','),
      expires: 10.years.from_now
    }
    redirect_to admin_utilizations_path
  end

  private
    def watching_bot_ids
      (cookies[CookieKey].presence || '').split(',').map(&:to_i)
    end
end