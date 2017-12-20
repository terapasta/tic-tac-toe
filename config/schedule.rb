# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# FIXME bot_id: 1をslack用botにしたので、一旦Twitterでは動作しないようにする
# every 2.minutes do
#   rake 'twitter:reply'
# end
#
# every 1.day, at: '18:52' do
#   rake 'twitter:auto_reply'
# end
#
# every 1.hours, at: '8:52' do
#   rake 'twitter:favorite'
# end
#
# every 1.day, at: ['12:38', '18:58'] do
#   rake 'twitter:auto_tweet'
# end
#
# every 1.day, at: '23:58' do
#   rake 'twitter:clone_tweets'
# end

every 1.day, at: 'am 8:00' do
  rake 'organization:check_finishing_trial'
end

every 1.day, at: 'am 18:00' do
  rake 'slack:notify_accuracy'
end
