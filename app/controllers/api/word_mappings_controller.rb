class Api::WordMappingsController < Api::BaseController
  before_action :set_word_mapping, only: [:update, :destroy]

  def create
    @word_mapping = WordMapping.new(permitted_attributes(WordMapping))
    authorize @word_mapping
    if @word_mapping.save
      render json: @word_mapping, adapter: :json
    else
      render_errors
    end
  end

  def update
    if @word_mapping.update(permitted_attributes(@word_mapping))
      render json: @word_mapping, adapter: :json
    else
      render_errors
    end
  end

  def destroy
    @word_mapping.destroy!
    render json: {}, status: :no_content
  end

  private
    def render_errors
      render json: { errors: @word_mapping.errors.full_messages }, status: :unprocessable_entity
    end

    def set_word_mapping
      @word_mapping = WordMapping.systems.find(params[:id])
      authorize @word_mapping
    end
end
