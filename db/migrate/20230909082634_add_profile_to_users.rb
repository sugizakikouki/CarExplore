class AddProfileToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :profile, :text
  end
end
