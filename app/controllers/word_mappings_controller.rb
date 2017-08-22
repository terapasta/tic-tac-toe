class WordMappingsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_word_mapping, only: [:show, :edit, :update, :destroy]

  def index
    @per_page = 20
    @word_mappings = @bot.word_mappings
      .keyword(params[:keyword])
      .order(created_at: :desc)
      .page(params[:page]).per(@per_page)
  end

  def new
    @word_mapping = @bot.word_mappings.build
  end

  def edit
  end

  def create
    @word_mapping = @bot.word_mappings.build(word_mapping_params.merge(bot_id: @bot.id))

    if @word_mapping.save
      @bot.learn_later
      redirect_to edit_bot_word_mapping_path(@bot, @word_mapping), notice: '同義語を登録しました。'
    else
      render :new
    end
  end

  def update
    if @word_mapping.update(word_mapping_params.merge(bot_id: @bot.id))
      @bot.learn_later
      redirect_to edit_bot_word_mapping_path(@bot, @word_mapping), notice: '同義語を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @word_mapping.destroy
    @bot.learn_later
    redirect_to bot_word_mappings_path(@bot), notice: '同義語を削除しました。'
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_word_mapping
      @word_mapping = @bot.word_mappings.find(params[:id])
    end

    def word_mapping_params
      params.require(:word_mapping).permit(:word, :synonym, word_mapping_synonyms_attributes: [:id, :value, :_destroy])
    end
end
