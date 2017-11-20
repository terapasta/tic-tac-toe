namespace :organization do
  desc 'trialプランのorganizationをチェックして終了1週間前の連絡を送る'
  task check_finishing_trial: :environment do
    Organization.all.each do |org|
      if org.before_1week_of_finishing_trail?
        OrganizationMailer.notify_before_1week_of_finishing_trial(org).deliver_now
      end
    end
  end
end