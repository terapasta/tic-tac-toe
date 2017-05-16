AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.fog_directory = ENV['AWS_S3_BUCKET_NAME']
  config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.existing_remote_files = 'delete'
  config.fog_region = 'ap-northeast-1'
  config.gzip_compression = true
  config.manifest = true
  config.fail_silently = true
end