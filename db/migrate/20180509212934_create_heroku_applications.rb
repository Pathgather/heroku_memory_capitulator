class CreateHerokuApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :heroku_applications, id: :uuid do |t|
      t.string :name
      t.string :encrypted_oauth_token
      t.string :encrypted_oauth_token_iv
      # NOTE: This is the time between restarts if mutiple requests for
      # restarts are made.
      t.integer :grace_period

      t.timestamps
    end
  end
end
