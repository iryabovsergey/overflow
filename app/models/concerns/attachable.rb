module Attachable
  extend ActiveSupport::Concern
  included do
    has_many :attachments, as: :attachmentable, dependent: :destroy
    accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attrib| attrib['file'].nil? }
  end
end