class WordMappings::ExportsController < ApplicationController
  include BotUsable

  def show
    @bot = bots.find(params[:bot_id])

    respond_to do |format|
      format.html
      format.csv do
        csv = @bot.word_mappings.decorate.to_csv
        csv.encode!(Encoding::Shift_JIS) if params[:encoding] == 'sjis'
        send_data csv,
          filename: "My-ope辞書データ-#{Time.current.strftime('%Y%m%d-%H%M%S')}.csv",
          type: 'text/csv'
      end
    end
  end
end