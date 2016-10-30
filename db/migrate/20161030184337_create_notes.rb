class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.integer :folder_id

      t.timestamps
    end
  end
end
