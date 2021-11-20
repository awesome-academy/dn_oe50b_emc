class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.string :comment
      t.string :rate
      t.references :user, null: false, foreign_key: true
      t.references :products, null: false, foreign_key: true

      t.timestamps
    end
  end
end
