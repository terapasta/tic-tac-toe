class TrainingText < ActiveRecord::Base
  acts_as_taggable_on :labels
  acts_as_taggable

  def self.build_by_sample
    body_sample = Message.guest.sample.body  # TODO テキストの取得元どうする？
    TrainingText.new(body: body_sample)
  end
end
