class AddUniqIndexToIpMatches < ActiveRecord::Migration[5.2]
  def change
    add_index :matches, :ip, unique: true
  end
end
