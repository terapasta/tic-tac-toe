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
      if @bot
        send("new_bot_#{ resource_name }_path", bot)
      else
        send("new_#{ resource_name }_path")
      end
    end

    def index_path
      if @bot
        send("bot_#{ params[:controller] }_path", @bot)
      else
        send("#{ params[:controller] }_path")
      end
    end

    def imported_training_message_params
      @_itm_params ||= permitted_params(ImportedTrainingMessage, current_user)
    end

    def imported_training_messages
      (@bot.try(:imported_training_messages) || ImportedTrainingMessage.all).includes(:bot)
    end

    def sentence_synonyms
      (@bot.try(:sentence_synonyms) || SentenceSynonym.all).includes(:created_user)
    end
end
