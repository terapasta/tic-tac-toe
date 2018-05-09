class AnswerInlineImageSerializer < ActiveModel::Serializer
  attributes :file

  def file
    if Rails.env.development?
      { url: 'http://localhost:3000' + object.file_url }
    else
      object.file
    end
  end
end