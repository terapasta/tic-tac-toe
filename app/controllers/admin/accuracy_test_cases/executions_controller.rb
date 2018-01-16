class Admin::AccuracyTestCases::ExecutionsController < ApplicationController
  def create
    AllBotAccuracyTestsJob.perform_now

    redirect_to root_path, notice: 'Succeeded all bot accuracy tests'
  end
end
