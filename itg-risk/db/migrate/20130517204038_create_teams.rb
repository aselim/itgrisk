class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :team
      t.integer :power
      t.integer :utilized
      t.text :Attack
      t.boolean :status

      t.timestamps
    end
  end
end
