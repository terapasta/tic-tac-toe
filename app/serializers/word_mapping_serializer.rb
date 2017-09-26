class WordMappingSerializer < ActiveModel::Serializer
  attributes :id, :word
  has_many :synonyms

  def synonyms
    object.word_mapping_synonyms
  end
end
