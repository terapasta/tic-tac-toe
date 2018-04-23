module Wakatifier
  def self.apply(text)
    Natto::MeCab.new('-Owakati').parse(text || '').sub(/\n$/, '')
  end
end