class AddAttachmentImageToDocumentPages < ActiveRecord::Migration
  def self.up
    change_table :document_pages do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :document_pages, :image
  end
end
