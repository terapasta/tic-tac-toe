module Wakatifier
  def self.apply(text)
    Natto::MeCab.new('-Owakati').parse(text.to_s).sub(/\n$/, '')
  end
end