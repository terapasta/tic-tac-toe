class Admin::Bots::AccuracyTestCasesController < Admin::Bots::BaseController
  include BotUsable
  before_action :set_accuracy_test_case, only: [:edit, :update, :destroy]

  def index
    @accuracy_test_cases = @bot.accuracy_test_cases
  end

  def create
<<<<<<< HEAD
    @accuracy_test_case = @bot.accuracy_test_cases.build(permitted_attributes(AccuracyTestCase))
=======
    @accuracy_test_case = @bot.accuracy_test_cases.build(permitted_attributes(AccracyTestCase))
>>>>>>> Implement line bot
    message = if @accuracy_test_case.save
      { notice: 'テストの追加に成功しました。' }
    else
      { alert: 'テストの追加に失敗しました。' }
    end
    redirect_to admin_bot_accuracy_test_cases_path(@bot), message
  end

  def edit
  end

  def update
    if @accuracy_test_case.update(permitted_attributes(@accuracy_test_case))
      redirect_to admin_bot_accuracy_test_cases_path(@bot), notice: 'テストを編集しました。'
    else
      redirect_to edit_admin_bot_accuracy_test_case_path(@bot, @accuracy_test_case), alert: 'テストの編集に失敗しました。'
    end
  end

  def destroy
    @accuracy_test_case.destroy
    redirect_to admin_bot_accuracy_test_cases_path(@bot), notice: 'テストを削除しました。'
  end

  private
    def set_accuracy_test_case
      @accuracy_test_case = @bot.accuracy_test_cases.find(params[:id])
    end
end
