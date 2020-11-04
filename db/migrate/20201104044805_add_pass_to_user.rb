class AddPassToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pass, :text
  end
end
