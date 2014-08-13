class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :description, null: false
      t.integer :amount, null: false
      t.string :currency
      t.string :interval
      t.integer :interval_count
      t.integer :trial_days
      t.timestamps
    end
  end
end
