class AnswerFileSerializer < ActiveModel::Serializer
  attributes :id, :file, :file_size, :file_type
end