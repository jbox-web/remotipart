class AddOtherAttachmentToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :other_attachment_file_name,    :string
    add_column :comments, :other_attachment_content_type, :string
    add_column :comments, :other_attachment_file_size,    :integer
    add_column :comments, :other_attachment_updated_at,   :datetime
  end
end
