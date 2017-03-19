module CsvGeneratable
  extend ActiveSupport::Concern

  def to_csv(encoding: :utf8)
    csv = CSV.generate(force_quotes: true, row_sep: "\r\n") { |csv|
      object.find_each do |item|
        recursive_put_rows_to_csv(csv, [item.question], item.answer)
      end
    }
    convert_csv_encoding(csv, encoding)
  end

  private
    def recursive_put_rows_to_csv(csv, base, answer)
      row = base.dup
      row << answer.body if answer.present?
      if answer&.decision_branches.present?
        answer.decision_branches.each do |decision_branch|
          row2 = row.dup
          row2 << decision_branch.body
          if decision_branch.next_answer.present?
            recursive_put_rows_to_csv(csv, row2, decision_branch.next_answer)
          else
            csv << row2
          end
        end
      else
        csv << row
      end
    end

    def convert_csv_encoding(csv, encoding)
      case encoding
      when :utf8
        csv
      when :sjis
        # FIXME 〜などが変換時に情報落ちしてしまう
        csv.encode(Encoding::SJIS, replace: '')
      end
    end
end
