class Admin::AccuracyTestCases::ExecutionsController < ApplicationController
  def create
    AllBotAccuracyTestsJob.perform_later

    redirect_to root_path, notice: 'Succeeded all bot accuracy tests'
  end
end
