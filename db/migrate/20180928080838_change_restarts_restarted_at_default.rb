class ChangeRestartsRestartedAtDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :restarts, :restarted_at, -> { 'now()' }
  end
end
