class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.string :ip
      t.text :logins

      t.timestamps
    end
  end
end
