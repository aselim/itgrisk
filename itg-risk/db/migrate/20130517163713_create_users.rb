class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.string :password_salt
      t.integer :team
      t.string :fname
      t.string :lname

      t.timestamps
    end
  end
end
