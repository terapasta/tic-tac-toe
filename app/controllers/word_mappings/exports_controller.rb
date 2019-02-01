class WordMappings::ExportsController < ApplicationController
  include BotUsable

  def show
    @bot = bots.find(params[:bot_id])

    respond_to do |format|
      format.html
      format.csv do
        csv = @bot.word_mappings.decorate.to_csv
        charset = 'utf-8'
        if params[:encoding] == 'sjis'
          charset = 'Shift_JIS'
          csv = SjisSafeConverter
            .sjis_safe(csv)
            .encode(Encoding::SJIS, invalid: :replace, undef: :replace, replace: '?')
        end
        send_data csv,
          filename: "My-ope辞書データ-#{Time.current.strftime('%Y%m%d-%H%M%S')}.csv",
          type: "text/csv; charset=#{charset}"
      end
    end
  end
end