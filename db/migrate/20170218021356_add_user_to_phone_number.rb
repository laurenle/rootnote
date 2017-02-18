class AddUserToPhoneNumber < ActiveRecord::Migration[5.0]
  def change
    add_reference :phone_numbers, :user, foreign_key: true
  end
end
