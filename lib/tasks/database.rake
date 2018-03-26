namespace :database do
  desc 'ダンプを作成してS3に保存する'
  task mysqldump_s3: :environment do
    connection = Fog::Storage.new({
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
    })
    bucket_name = ENV['AWS_S3_BUCKET_NAME']
    bucket = connection.directories.get(bucket_name)
    db_config = Rails.configuration.database_configuration[Rails.env]
    time_format = '%Y%m%d'
    file_name = "database-#{Time.current.strftime(time_format)}.dump"
    fifteen_ago_file_name = "database-#{15.days.ago.strftime(time_format)}.dump"
    file_key = "mysqldumps/#{file_name}"
    bucket_file_key = "#{bucket_name}/#{file_key}"
    fifteen_ago_file_key = "mysqldumps/#{fifteen_ago_file_name}"
    output_path = Rails.root.join("tmp/#{file_name}")

    succeeded = system("mysqldump -u #{db_config['username']} --password=#{db_config['password']} -h #{db_config['host']} #{db_config['database']} > #{output_path}")

    unless succeeded
      puts 'Failed create mysql dump'
      exit 1
    end

    if bucket.files.get(file_key)
      puts "Already exists #{bucket_file_key}"
    else
      bucket.files.create(
        key: file_key,
        public: false,
        body: Rails.root.join(output_path).read
      ).tap do |f|
        if f
          puts "Created #{bucket_file_key}"
        else
          puts "Failed create #{bucket_file_key}"
        end
      end
    end

    bucket.files.get(fifteen_ago_file_key).tap do |f|
      p "Deleted #{bucket_name}/#{fifteen_ago_file_key}" if f && f.destroy
    end
  end
end