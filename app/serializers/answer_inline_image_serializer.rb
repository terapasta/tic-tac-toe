require 'carrierwave/storage/fog'

class AnswerInlineImageSerializer < ActiveModel::Serializer
  attributes :file

  def file
    if CarrierWave::Uploader::Base.storage == CarrierWave::Storage::Fog
      object.file
    else
      { url: 'http://localhost:3000' + object.file_url }
    end
  end
end