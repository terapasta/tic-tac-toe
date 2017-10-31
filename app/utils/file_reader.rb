class FileReader
  def initialize(file_path:, encoding:)
    @file_path = file_path
    @encoding = encoding
  end

  def read
    File.open(@file_path, mode_enc, undef: :replace)
      .read
      .gsub(/\r\n/, "\n")
      .gsub(/\r/, "\n")
  end

  def mode_enc
    case @encoding
    when Encoding::UTF_8 then 'r'
    when Encoding::Shift_JIS then 'rb:Shift_JIS:UTF-8'
    end
  end
end
