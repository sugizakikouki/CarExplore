class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :visitor, null: false, foreign_key: { to_table: :users}
      t.references :visited, null: false, foreign_key: { to_table: :users}
      t.references :post, null: true, foreign_key: true
      t.references :comment, null: true, foreign_key: true
      t.string :action
      t.boolean :checked

      t.timestamps
    end
  end
end
