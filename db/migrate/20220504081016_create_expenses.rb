class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :category
      t.integer :amount

      t.timestamps
    end
  end
end
