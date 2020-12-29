class Comment < ActiveRecord::Base
  validates :subject, :body, presence: true
  mount_uploader :attachment, AttachmentUploader
  mount_uploader :other_attachment, AttachmentUploader
end
