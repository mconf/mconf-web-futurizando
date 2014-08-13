class AddPaypalToSites < ActiveRecord::Migration
  def change
    add_column :sites, :paypal_username_live, :string
    add_column :sites, :paypal_password_live, :string
    add_column :sites, :paypal_signature_live, :string
    add_column :sites, :paypal_username_test, :string
    add_column :sites, :paypal_password_test, :string
    add_column :sites, :paypal_signature_test, :string
    add_column :sites, :paypal_sandbox, :boolean, default: true
  end
end
