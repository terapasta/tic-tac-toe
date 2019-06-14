class QuestionAnswersController < ApplicationController
  include BotUsable
  include QuestionAnswersSearchable

  before_action :set_bot
  before_action :set_question_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_topic_tags, only: [:index]
  before_action :set_bulk_delete_question_answers, only: [:bulk_delete]

  def index
    authorize QuestionAnswer
    session[:question_answers_queries] = request.query_parameters
    @topic_tags = @bot.topic_tags
    @keyword = params[:keyword]
    @current_page = current_page
    @per_page = QuestionAnswer.default_per_page
    @topic_id = params.dig(:topic, :id)
    @q = search_question_answers(
      bot: @bot,
      topic_id: @topic_id,
      keyword: params[:keyword],
      q: params[:q],
      page: @current_page,
      per_page: @per_page,
    )
    @question_answers = @q.result
  end

  def show
    @question_answer = @bot.question_answers.find params[:id]
    if params[:qacard] == 'true'
      @is_modal = params[:is_modal]
      render :show, layout: false and return
    end
    respond_to do |format|
      format.json do
        render json: @question_answer.decorate.as_json(include: [:topic_tags])
      end
    end
  end

  def new
    @question_answer = @bot.question_answers.build(
      question: params[:question],
      answer: params[:answer],
    )
    authorize @question_answer
  end

  def create
    respond_to do |format|
      @question_answer = @bot.question_answers.build(question_answer_params)
      authorize @question_answer
      if @question_answer.save
        @bot.learn_later
        format.html { redirect_to bot_question_answers_path(@bot), notice: '登録しました。' }
        format.json { render json: @question_answer.decorate.as_json, status: :created }
      else
        format.html do
          flash.now.alert = '登録できませんでした。'
          render :edit
        end
        format.json { render json: @question_answer.decorate.errors_as_json, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @task = @bot.tasks.find_by(id: params[:task_id])
  end

  def update
    need_learning = should_learning?
    if @question_answer.save
      @bot.learn_later if need_learning
      respond_to do |format|
        format.html do
          redirect_to edit_bot_question_answer_path(@bot, @question_answer), notice: '更新しました。'
        end
        format.json { render json: @question_answer.decorate.as_json, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash.now.alert = '更新できませんでした。'
          render :edit
        end
        format.json { render json: @question_answer.decorate.errors_as_json, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      begin
        format.html do
          @question_answer.destroy!
          @bot.learn_later
          redirect_to bot_question_answers_path(@bot), notice: '削除しました。'
        end
        format.json do
          ActiveRecord::Base.transaction do
            @question_answer.self_and_deep_child_decision_branches.map(&:destroy!)
          end
          @bot.learn_later
          render json: {}, status: :no_content
        end
      rescue => e
        format.html { raise e }
        format.json do
          logger.error e.message + e.backtrace.join("\n")
          render json: { error: e.message }, status: :internal_server_error
        end
      end
    end
  end

  def bulk_delete
    n = @question_answers.count
    if n == 0
      return redirect_to bot_question_answers_path(@bot), alert: "削除する Q/A を選択してください。"
    end

    deleted = @question_answers.destroy_all
    if n != deleted.count
      return redirect_to bot_question_answers_path(@bot), alert: "#{n - deleted.count}件の削除に失敗しました。しばらく時間を置いてから再度お試しください。"
    end

    @bot.learn_later
    redirect_to bot_question_answers_path(@bot), notice: "#{n}件の Q/A を削除しました。"
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find params[:id]
      authorize @question_answer
    end

    def set_topic_tags
      @topic_tags = @bot.topic_tags
    end

    def set_bulk_delete_question_answers
      delete_params = params.fetch(:question_answer, {should_delete: {}}).permit(should_delete: {})
      delete_ids = delete_params.to_hash['should_delete'].keys
      @question_answers = QuestionAnswer.where(id: delete_ids)
    end

    def question_answer_params
      @question_answer_params ||= permitted_attributes(@question_answer || QuestionAnswer).tap do |prm|
        if prm[:answer_attributes].present?
          prm[:answer_attributes][:bot_id] = @bot.id
        end
      end
    end

    def index_path_helper_name
      :bot_question_answers_path
    end

    def should_learning?
      @question_answer.assign_attributes(question_answer_params)
      @question_answer.question_changed? || @question_answer.has_changed_sub_question? ? true : false
    end
end
