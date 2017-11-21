class Admin::WordMappingsController < ApplicationController
  before_action :set_word_mapping, only: [:show, :edit, :update, :destroy]

  def index
    @per_page = 50
    @word_mappings = WordMapping
      .where(bot_id: nil)
      .keyword(params[:q])
      .order('created_at DESC')
      .page(params[:page]).per(@per_page)
  end

  def new
    @word_mapping = WordMapping.new
    @word_mapping.word_mapping_synonyms.build
  end

  def edit
  end

  def create
    @word_mapping = WordMapping.new(permitted_attributes(WordMapping))

    if @word_mapping.save
      redirect_to admin_word_mappings_path, notice: '同義語を登録しました。'
    else
      render :new
    end
  end

  def update
    if @word_mapping.update(permitted_attributes(@word_mapping))
      redirect_to admin_word_mappings_path, notice: '同義語を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @word_mapping.destroy
    redirect_to admin_word_mappings_url, notice: '同義語を削除しました。'
  end

  private
    def set_word_mapping
      @word_mapping = WordMapping.find(params[:id])
    end
end
