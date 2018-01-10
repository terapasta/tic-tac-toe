class FileReader
  def initialize(file_path:, encoding:)
    @file_path = file_path
    @encoding = encoding
  end

  def read
    raw_data = File.open(@file_path, mode_enc).read

    if @encoding == Encoding::Shift_JIS
      raw_data = IncompatibleChars.new(raw_data).convert
    end

    raw_data = raw_data
      .gsub(/\r\n/, "\n")
      .gsub(/\r/, "\n")

    raw_data
  end

  def mode_enc
    case @encoding
    when Encoding::UTF_8 then 'r'
    when Encoding::Shift_JIS then 'r:shift_jis:shift_jis'
    end
  end
end
