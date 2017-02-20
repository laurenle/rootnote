class AddPhoneNumberToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :phone_number, foreign_key: true
  end
end
