class WordMappingsController < ApplicationController
  before_action :set_word_mapping, only: [:show, :edit, :update, :destroy]

  # GET /word_mappings
  # GET /word_mappings.json
  def index
    @word_mappings = WordMapping.all
  end

  # GET /word_mappings/1
  # GET /word_mappings/1.json
  def show
  end

  # GET /word_mappings/new
  def new
    @word_mapping = WordMapping.new
  end

  # GET /word_mappings/1/edit
  def edit
  end

  # POST /word_mappings
  # POST /word_mappings.json
  def create
    @word_mapping = WordMapping.new(word_mapping_params)

    respond_to do |format|
      if @word_mapping.save
        format.html { redirect_to @word_mapping, notice: 'Word mapping was successfully created.' }
        format.json { render :show, status: :created, location: @word_mapping }
      else
        format.html { render :new }
        format.json { render json: @word_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /word_mappings/1
  # PATCH/PUT /word_mappings/1.json
  def update
    respond_to do |format|
      if @word_mapping.update(word_mapping_params)
        format.html { redirect_to @word_mapping, notice: 'Word mapping was successfully updated.' }
        format.json { render :show, status: :ok, location: @word_mapping }
      else
        format.html { render :edit }
        format.json { render json: @word_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /word_mappings/1
  # DELETE /word_mappings/1.json
  def destroy
    @word_mapping.destroy
    respond_to do |format|
      format.html { redirect_to word_mappings_url, notice: 'Word mapping was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word_mapping
      @word_mapping = WordMapping.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_mapping_params
      params.fetch(:word_mapping, {})
    end
end
