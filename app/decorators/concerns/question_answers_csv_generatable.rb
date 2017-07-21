module QuestionAnswersCsvGeneratable
  extend ActiveSupport::Concern

  include CsvGeneratable

  def to_csv(encoding: :utf8)
    super(encoding: encoding.to_sym) do |csv, item|
      recursive_put_rows_to_csv(csv, [item.id, item.question, item.answer], item.decision_branches)
    end
  end

  private
    def recursive_put_rows_to_csv(csv, base, decision_branches)
      row = base.dup
      if decision_branches.any?
        decision_branches.each do |decision_branch|
          row2 = row.dup
          row2 << decision_branch.body
          row2 << decision_branch.answer
          recursive_put_rows_to_csv(csv, row2, decision_branch.child_decision_branches)
        end
      else
        csv << row
      end
    end
end
