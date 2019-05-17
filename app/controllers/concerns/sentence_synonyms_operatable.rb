module SentenceSynonymsOperatable
  extend ActiveSupport::Concern

  private
    def permitted_params(model_class, current_user)
      permitted_attributes(model_class).tap do |_params|
        key = :sentence_synonyms_attributes
        _params[key] = _params[key].values
          .each{ |ss| ss[:created_user_id] = current_user.id }
          .select{ |ss| ss[:body].present? }
      end
    end

    def new_path
      resource_name = params[:controller].singularize
      if %w[bot imported sentence synonym].include?(resource_name)
        if @bot
          new_polymorphic_path([ @bot, resource_name ])
        else
          new_polymorphic_path([ resource_name ])
        end
      end
    end

    def index_path
      if %w[bot imported sentence synonym].include?(params[:controller])
        if @bot
          polymorphic_path([ @bot, params[:controller] ])
        else
          polymorphic_path([ params[:controller] ])
        end
      end
    end

    def question_answer_params
      @_itm_params ||= permitted_params(QuestionAnswer, current_user)
    end

    def question_answers
      (@bot.try(:question_answers) || QuestionAnswer.all).includes(:bot)
    end

    def sentence_synonyms
      (@bot.try(:sentence_synonyms) || SentenceSynonym.all).includes(:created_user)
    end
end
