class WordMappingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_word_mapping, only: [:show, :edit, :update, :destroy]

  def index
    @word_mappings = current_user.word_mappings.page(params[:page]).per(params[:per])
  end

  def new
    @word_mapping = current_user.word_mappings.build
  end

  def edit
  end

  def create
    @word_mapping = current_user.word_mappings.build(word_mapping_params)

    if @word_mapping.save
      redirect_to word_mappings_path, notice: '同義語を登録しました。'
    else
      render :new
    end
  end

  def update
    if @word_mapping.update(word_mapping_params)
      redirect_to word_mappings_path, notice: '同義語を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @word_mapping.destroy
    redirect_to word_mappings_url, notice: '同義語を削除しました。'
  end

  private

    def set_word_mapping
      @word_mapping = current_user.word_mappings.find(params[:id])
    end

    def word_mapping_params
      params.require(:word_mapping).permit(:word, :synonym)
    end
end
