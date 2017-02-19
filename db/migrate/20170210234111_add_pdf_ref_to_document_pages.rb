class AddPdfRefToDocumentPages < ActiveRecord::Migration[5.0]
  def change
    add_column :document_pages, :pdf_id, :integer
  end
end
