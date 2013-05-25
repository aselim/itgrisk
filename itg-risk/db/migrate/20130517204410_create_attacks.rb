class CreateAttacks < ActiveRecord::Migration
  def change
    create_table :attacks do |t|
      t.string :attack

      t.timestamps
    end
  end
end
