class Export < ActiveRecord::Base
  belongs_to :bot
  enum encoding: [:utf8, :sjis]
  mount_uploader :file, ExportFileUploader

  def with_tmp_file(file_body:, extension:, &block)
    maker = Export::TmpFileMaker.new(
      file_body: file_body,
      extension: extension,
      encoding: encoding_i18n,
    )
    maker.write
    block.call(maker.file)
    maker.delete
  end
end
