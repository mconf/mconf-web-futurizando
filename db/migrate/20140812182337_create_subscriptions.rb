class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :plan, null: false
      t.belongs_to :user, null: false
      t.string :code
      t.string :paypal_id
      t.string :paypal_token
      t.boolean :completed, default: false
      t.boolean :canceled, default: false
      t.timestamps
    end
  end
end