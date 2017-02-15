module SentenceSynonymsOperatable
  class IndexOperator
    attr_reader :params, :current_user, :bot

    def initialize(controller)
      @controller = controller
      @params = controller.params
      @current_user = controller.current_user
      @bot = controller.instance_variable_get(:@bot)
      @controller.instance_variable_set(:@worker_id, worker_id)
      @controller.instance_variable_set(:@target_date, target_date)
    end

    def worker_id
      @worker_id ||= \
        (current_user.worker? && current_user.id) ||
        params.dig(:filter, :worker_id)&.to_i
    end

    def target_date
      @target_date ||= begin
        year = params.dig(:filter, 'target_date(1i)').presence || nil
        month = params.dig(:filter, 'target_date(2i)').presence || nil
        day = params.dig(:filter, 'target_date(3i)').presence || nil
        unless [year, month, day].include?(nil)
          Date.new(year.to_i, month.to_i, day.to_i)
        end
      end
    end

    def can_render_index?
      force? || selected_target_date_or_worker_id?
    end

    def need_alert?
      !can_render_index?
    end

    def force?
      params[:force].present?
    end

    def selected_target_date_or_worker_id?
      worker_id.present? || target_date.present?
    end

    def process
      filtered_question_answers = question_answers.inject({}) { |res, qa|
        res[qa] = qa.sentence_synonyms.select { |ss|
          is_target_date = ss.created_at.to_date == target_date
          is_created_user = ss.created_user_id == worker_id

          if target_date.present? && worker_id.present?
            is_target_date && is_created_user
          elsif target_date.present?
            is_target_date
          elsif worker_id.present?
            is_created_user
          else
            true
          end
        }
        res
      }
      @controller.instance_variable_set(:@filtered_question_answers, filtered_question_answers)
    end

    def question_answers
      @question_answers ||= begin
        qas = bot.try(:question_answers) || QuestionAnswer.all
        qas = qas.includes(:sentence_synonyms, :bot)
        @controller.instance_variable_set(:@question_answers, qas)
      end
    end
  end
end
