class CreatePdfs < ActiveRecord::Migration[5.0]
  def change
    create_table :pdfs do |t|

      t.timestamps
    end
  end
end
