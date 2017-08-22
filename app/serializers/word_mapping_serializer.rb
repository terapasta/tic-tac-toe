class WordMappingSerializer < ActiveModel::Serializer
  attributes :id, :word
  has_many :word_mapping_synonyms
end
