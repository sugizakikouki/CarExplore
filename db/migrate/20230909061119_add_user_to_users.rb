class AddUserToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string
    add_column :users, :name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :location, :string
  end
end
