class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer :Team
      t.string :Node
      t.string :Details
      t.integer :Power
      t.boolean :Aquired
      t.text :Attack
      t.text :Defense

      t.timestamps
    end
  end
end
