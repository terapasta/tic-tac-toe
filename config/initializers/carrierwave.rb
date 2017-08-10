if Rails.env.production? || Rails.env.staging?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                'ap-northeast-1'
      #hosts:                's3.example.com'
      #endpoint:             'https://s3.example.com:8080'
    }
    config.fog_directory  = ENV['AWS_S3_BUCKET_NAME']
    config.fog_public     = true
    config.fog_authenticated_url_expiration = 1.day.to_i
    config.storage = :fog
    config.asset_host = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3.amazonaws.com"
    # config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  end
elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Rails.root}/spec/support/uploads/tmp"
      end

      def store_dir
        "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
end
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
