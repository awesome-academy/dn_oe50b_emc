class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string
    add_column :users, :password_digest, :string
    add_column :users, :id_card, :string
    add_column :users, :phone_number, :string
    add_column :users, :address, :string
  end
end
