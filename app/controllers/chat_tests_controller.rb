class ChatTestsController < ApplicationController
  include BotUsable
  before_action :set_bot

  def show
    redirect_to new_bot_chat_tests_path(@bot) and return if @bot.chat_test_results.blank?
    respond_to do |format|
      format.html do
        @bot_test_results = @bot.chat_test_results
      end

      format.csv do
        csv = CSV.generate(
          force_quotes: true,
          encoding: resolve_encoding_from_params(:encode)
        ) { |csv|
          csv << ['テスト質問', '得られた回答', 'サジェスト質問']
          @bot.chat_test_results.each do |data|
            set_data = [data[0], data[1], data[2].map{ |it| "* #{it}" }.join("\r\n")]
            csv << set_data
          end
        }
        send_data csv, type: :csv, filename: "test_result.csv"
      end
    end
  end

  def create
    if params[:file].blank? || File.extname(params[:file].path) != ".csv"
      redirect_to new_bot_chat_tests_path(@bot), alert: 'csvファイルを選択してください。'
      return
    end

    encoding = resolve_encoding_from_params(:commit)
    raw_data = FileReader.new(file_path: params[:file].path, encoding: encoding).read

    @bot.update(is_chat_test_processing: true, chat_test_results: nil, chat_test_job_error: '')
    ChatTestJob.perform_later(@bot, raw_data)

    redirect_to new_bot_chat_tests_path(@bot), notice: 'ボットテストを開始しました'
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def resolve_encoding_from_params(keyname)
      params[keyname].include?('UTF-8') ?
        Encoding::UTF_8 : Encoding::Shift_JIS
    end
end
