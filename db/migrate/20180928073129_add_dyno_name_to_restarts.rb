class AddDynoNameToRestarts < ActiveRecord::Migration[5.2]
  def change
    add_column :restarts, :dyno_name, :string
    add_index :restarts, :dyno_name
  end
end
