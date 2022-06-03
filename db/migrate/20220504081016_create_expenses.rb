class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :category, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
