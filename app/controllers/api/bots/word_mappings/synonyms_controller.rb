class Api::Bots::WordMappings::SynonymsController < Api::BaseController
  before_action :set_bot
  before_action :set_word_mapping
  before_action :set_synonym, only: [:update, :destroy]

  def create
    @synonym = @word_mapping.word_mapping_synonyms.build(permitted_attributes(WordMappingSynonym))
    authorize @synonym
    if @synonym.save
      render json: @synonym, adapter: :json
    else
      render_errors
    end
  end

  def update
    if @synonym.update(permitted_attributes(@synonym))
      render json: @synonym, adapter: :json
    else
      render_errors
    end
  end

  def destroy
    @synonym.destroy!
    render json: {}, status: :no_content
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_word_mapping
      @word_mapping = @bot.word_mappings.find(params[:word_mapping_id])
      authorize @word_mapping
    end

    def set_synonym
      @synonym = @word_mapping.word_mapping_synonyms.find(params[:id])
      authorize @synonym
    end

    def render_errors
      render json: { errors: @synonym.errors.full_messages }, status: :unprocessable_entity
    end
end
