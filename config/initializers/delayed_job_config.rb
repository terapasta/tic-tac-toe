# Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.sleep_delay = 1
Delayed::Worker.delay_jobs = !Rails.env.test?

