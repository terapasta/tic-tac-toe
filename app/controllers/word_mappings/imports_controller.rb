class WordMappings::ImportsController < ApplicationController
  include BotUsable
  before_action :set_bot

  def show
  end

  def create
    encoding = params[:commit]&.include?('UTF-8') ? Encoding::UTF_8 : Encoding::Shift_JIS
    file_reader = FileReader.new(file_path: params[:file].path, encoding: encoding)
    CSV.parse(file_reader.read).drop(1).each do |row|
      word = row[0]
      synonyms = row.drop(1)
      ActiveRecord::Base.transaction do
        word_mapping = @bot.word_mappings.find_or_create_by!(word: word)
        synonyms.each do |synonym|
          word_mapping.word_mapping_synonyms.find_or_create_by!(value: synonym)
        end
      end
    end
    redirect_to bot_import_word_mappings_path(@bot), notice: '辞書をインポートしました'
  rescue => e
    logger.error e.message
    flash.now.alert = '辞書をインポートできませんでした'
    render :show
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end
end