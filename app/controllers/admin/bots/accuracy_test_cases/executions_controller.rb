class Admin::Bots::AccuracyTestCases::ExecutionsController < Admin::Bots::BaseController
  include ReplyTestable

  def create
    test_result = accuracy_test!(@bot)
    @accuracy_test_cases = test_result.accuracy_test_cases
    @result = test_result.details
    @success_count_text = "#{test_result.success_count} 成功 / #{test_result.accuracy_test_cases.count} total,"
    @success_percentage_text = "成功率 #{(test_result.accuracy * 100).to_i}%"
    render 'admin/bots/accuracy_test_cases/index'
  end
end
