module QuestionAnswersCsvGeneratable
  extend ActiveSupport::Concern

  include CsvGeneratable

  def to_csv(encoding: :utf8)
    super(encoding: encoding.to_sym) do |csv, item|
      recursive_put_rows_to_csv(csv, [item.id, item.question], item.answer)
    end
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
end
