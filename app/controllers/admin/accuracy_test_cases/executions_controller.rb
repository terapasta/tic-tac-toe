class Admin::AccuracyTestCases::ExecutionsController < ApplicationController
  def create
    Delayed::Job.enqueue AllBotAccuracyTestsJob.new

    redirect_to root_path, notice: 'Succeeded all bot accuracy tests'
  end
end
