if Rails.env.production? || Rails.env.staging?
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.fog_directory = ENV['AWS_S3_BUCKET_NAME']
    config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
    config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    config.existing_remote_files = 'delete'
    config.fog_region = 'ap-northeast-1'
    config.gzip_compression = true
    config.manifest = false
    config.fail_silently = true
    config.run_on_precompile = false
    # webpacker対応
    config.add_local_file_paths do
      # Any code that returns paths of local asset files to be uploaded
      # Like Webpacker
      public_root = Rails.root.join("public")
      Dir.chdir(public_root) do
        packs_dir = Webpacker.config.public_output_path.relative_path_from(public_root)
        Dir[File.join(packs_dir, '/**/**')]
      end
    end
  end

  if Rake::Task.task_defined?("webpacker:compile")
    Rake::Task['webpacker:compile'].enhance do
      Rake::Task["assets:sync"].invoke
    end
  end
end
