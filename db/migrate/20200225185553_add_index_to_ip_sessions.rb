class AddIndexToIpSessions < ActiveRecord::Migration[5.2]
  def change
    add_index :sessions, :ip
  end
end
