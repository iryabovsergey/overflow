class Attachment < ApplicationRecord
  belongs_to :attachmentable, polymorphic: true, optional: true
  mount_uploader :file, FileUploader, ignore_processing_errors: true
  validates :file, presence: true
end
