class SjisSafeConverter
  def self.sjis_safe(str)
    return if str.nil?
    [
      ["FF5E", "007E"], # wave-dash
      ["FF0D", "002D"], # full-width minus
      ["00A2", "FFE0"], # cent as currency
      ["00A3", "FFE1"], # lb(pound) as currency
      ["00AC", "FFE2"], # not in boolean algebra
      ["2014", "2015"], # hyphen
      ["2016", "2225"], # double vertical lines
      ["FF0F", "002f"], # slash
    ].inject(str) do |s, (before, after)|
      s.gsub(
        before.to_i(16).chr('UTF-8'),
        after.to_i(16).chr('UTF-8'))
    end
  end

  def self.convert_all_question_answers(is_dryrun: true)
    _convert_all_for(QuestionAnswer, :question, is_dryrun)
  end

  def self.convert_all_answers(is_dryrun: true)
    _convert_all_for(Answer, :body, is_dryrun)
  end

  def self.convert_all_decision_branches(is_dryrun: true)
    _convert_all_for(DecisionBranch, :body, is_dryrun)
  end

  def self._convert_all_for(model, attr_name, is_dryrun)
    ActiveRecord::Base.transaction do
      model.find_each do |r|
        v = r.send(attr_name)
        sv = sjis_safe(v)
        next if v == sv
        if is_dryrun
          puts sv
        else
          r.send("#{attr_name}=", sv)
          r.save!
        end
      end
    end
  end
end
