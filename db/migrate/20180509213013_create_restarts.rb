class CreateRestarts < ActiveRecord::Migration[5.2]
  def change
    create_table :restarts do |t|
      t.references :heroku_application, foreign_key: true, type: :uuid
      t.datetime :restarted_at

      t.timestamps
    end
  end
end
