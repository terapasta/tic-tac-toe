class Export::TmpFileMaker
  attr_reader :file_body, :file_path, :file

  def initialize(file_body:, extension:, encoding:)
    @file_body = file_body
    @file_name = "#{SecureRandom.uuid}.#{extension}"
    @file_path = Rails.root.join("tmp/#{@file_name}")
    @file = File.new(@file_path, 'w+', encoding: encoding)
  end

  def write
    @file.write(@file_body)
  end

  def delete
    File.delete(@file)
  end
end
