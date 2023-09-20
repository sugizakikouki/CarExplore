class AddUsernameToAdmins < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :username, :string
  end
end
