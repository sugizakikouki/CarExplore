class AddUniqueIndexToUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :name, unique: true
    add_index :users, :username, unique: true
  end
end
