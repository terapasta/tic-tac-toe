namespace :organization do
  desc 'trialプランのorganizationをチェックして終了1週間前の連絡を送る'
  task check_finishing_trial: :environment do
    Organization.before_1week_of_finishing_trial.each do |org|
      OrganizationMailer.notify_before_1week_of_finishing_trial(org).deliver_now
    end
  end
end