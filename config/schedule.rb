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

env 'MECAB_PATH', '/usr/local/lib/libmecab.so'
env 'ZENDESK_HC_BOT_ID', 1

# 朝8:00
every 1.day, at: '8:00' do
  rake 'organization:check_finishing_trial'
end

# 夕方18:00
every 1.day, at: '18:00' do
  rake 'slack:notify_accuracy'
end

# 未明5:00
every 1.day, at: '5:00' do
  rake 'database:mysqldump_s3'
end

# 未明4:00
# every 1.day, at: '4:00' do
#   rake 'question_answer:import_mofmof_zendesk_hc'
# end

# 未明3:00
every 1.day, at: '3:00' do
  rake 'data_summary:calc_bad_counts'
end

every 1.day, at: '1:00' do
  rake 'data_summary:calc_guest_messages'
end

every 1.day, at: '2:00' do
  rake 'data_summary:calc_question_answers'
end
