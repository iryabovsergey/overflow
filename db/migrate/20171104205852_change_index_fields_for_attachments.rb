class ChangeIndexFieldsForAttachments < ActiveRecord::Migration[5.0]
  def change
    remove_index :attachments, :attachmentable_type
    add_index :attachments, [:attachmentable_id, :attachmentable_type]
  end
end
