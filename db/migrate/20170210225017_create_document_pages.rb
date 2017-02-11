class CreateDocumentPages < ActiveRecord::Migration[5.0]
  def change
    create_table :document_pages do |t|
      t.integer :number

      t.timestamps
    end
  end
end
