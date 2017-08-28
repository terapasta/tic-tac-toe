module CsvGeneratable
  extend ActiveSupport::Concern

  def to_csv(encoding: :utf8, &block)
    csv = CSV.generate(force_quotes: false, row_sep: "\r\n") { |csv|
      object.find_each do |item|
        block.call(csv, item)
      end
    }
    convert_csv_encoding(csv, encoding)
  end

  private
    def convert_csv_encoding(csv, encoding)
      case encoding
      when :utf8
        csv
      when :sjis
        # FIXME 〜などが変換時に情報落ちしてしまう
        SjisSafeConverter
          .sjis_safe(csv)
          .encode('Shift_JIS', invalid: :replace, undef: :replace, replace: '?')
      end
    end
end
