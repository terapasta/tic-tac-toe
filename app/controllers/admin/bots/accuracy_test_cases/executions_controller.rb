class Admin::Bots::AccuracyTestCases::ExecutionsController < Admin::Bots::BaseController
  include ReplyTestable

  def create
    @result = accuracy_test!(@bot)
    @success_count_text = "#{@result.success_count} 成功 / #{@result.accuracy_test_cases.count} total,"
    @success_percentage_text = "成功率 #{(@result.accuracy * 100).to_i}%"
    render 'admin/bots/accuracy_test_cases/index'
  end
end
