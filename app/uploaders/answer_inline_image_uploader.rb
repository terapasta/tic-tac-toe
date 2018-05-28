require 'carrierwave/storage/fog'

class AnswerInlineImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    filename = original_filename.presence || model.read_attribute(:file)
    "#{model.uuid}-#{filename}"
  end

  if CarrierWave::Uploader::Base.storage == CarrierWave::Storage::Fog
    def self.fog_public
      true
    end
  end
end
