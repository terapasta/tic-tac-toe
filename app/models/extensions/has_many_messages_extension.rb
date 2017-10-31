module HasManyMessagesExtension
  def answer_failed_count
    array_select_by(:answer_failed)
  end

  def good_count
    array_select_by(:good?)
  end

  def bad_count
    array_select_by(:bad?)
  end

  def answer_marked_count
    array_select_by(:answer_marked)
  end

  private
    def array_select_by(method_name)
      to_a.select{ |m| m.rating&.send(method_name) }.count
    end
end
