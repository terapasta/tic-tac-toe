class WordMappings::ExportsController < ApplicationController
  include BotUsable

  def show
    @bot = bots.find(params[:bot_id])

    respond_to do |format|
      format.html
      format.csv do
        csv = @bot.word_mappings.decorate.to_csv
        if params[:encoding] == 'sjis'
          SjisSafeConverter
            .sjis_safe(csv)
            .encode('Shift_JIS', invalid: :replace, undef: :replace, replace: '?')
        end
        send_data csv,
          filename: "My-ope辞書データ-#{Time.current.strftime('%Y%m%d-%H%M%S')}.csv",
          type: 'text/csv'
      end
    end
  end
end