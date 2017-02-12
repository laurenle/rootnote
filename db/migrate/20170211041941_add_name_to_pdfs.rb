class AddNameToPdfs < ActiveRecord::Migration[5.0]
  def change
    add_column :pdfs, :name, :string
  end
end
